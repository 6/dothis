require 'spec_helper'

describe User do
  it_behaves_like "a FactoryGirl class"

  describe "#create!" do
    it "fails if the user does not have a valid email" do
      expect { User.create!(email: "pg.com", password: "abcdef", username: "wut") }.to raise_error(ActiveRecord::RecordInvalid, /Email is invalid/)
    end

    it "fails if the email address is not unique" do
      User.create!(email: "p@g.com", password: "abcdef", username: "wut")
      expect { User.create!(email: "P@G.com", password: "abcdef", username: "wut2") }.to raise_error(ActiveRecord::RecordInvalid, /Email has already been taken/)
    end

    it "fails if the username is not unique" do
      User.create!(email: "p@g.com", password: "abcdef", username: "wut")
      expect { User.create!(email: "p@new.com", password: "abcdef", username: "Wut") }.to raise_error(ActiveRecord::RecordInvalid, /Username has already been taken/)
    end

    it "fails if the username is not present" do
      expect { User.create!(email: "p@g.com", password: "abcdef", username: "") }.to raise_error(ActiveRecord::RecordInvalid, /Username is too short/)
    end

    it "fails if the username is too long" do
      expect { User.create!(email: "p@g.com", password: "abcdef", username: "a"*31) }.to raise_error(ActiveRecord::RecordInvalid, /Username is too long/)
    end

    it "fails if the username contains non -_a-zA-Z0-9 characters" do
      expect { User.create!(email: "p@g.com", password: "abcdef", username: "a$") }.to raise_error(ActiveRecord::RecordInvalid, /Username is invalid/)
    end

    it "fails if the user's password is not >= 6 characters" do
      expect { User.create!(email: "p@g.com", password: "abc", username: "wut") }.to raise_error(ActiveRecord::RecordInvalid, /Password is too short/)
    end

    context "user's email, username, and password are valid" do
      it "creates a new User" do
        expect { User.create!(email: "p@g.com", password: "abcdef", username: "wut") }.to change { User.count }.by(1)
      end

      it "sets expected field values on User" do
        User.create!(email: "p@g.com", password: "abcdef", username: "wUt")
        User.last.tap do |u|
          u.email.should == "p@g.com"
          u.username.should == "wUt"
          u.password_digest.should_not be_nil
          u.auth_token.should_not be_nil
        end
      end

      it "is able to authenticate that user" do
        User.create!(email: "p@g.com", password: "abcdef", username: "wut")
        User.last.authenticate("wrongpass").should be_false
        User.last.authenticate("abcdef").should be_true
      end
    end
  end

  context "user is created" do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_with_tasks) { FactoryGirl.create(:user) }

    before do
      user_with_tasks.tasks.create!(title: "incomplete task")
      user_with_tasks.tasks.create!(title: "completed 1 day ago", completed_at: 1.day.ago)
      user_with_tasks.tasks.create!(title: "completed 1 day ago", completed_at: 1.day.ago)
      user_with_tasks.tasks.create!(title: "completed 3 days ago", completed_at: 3.days.ago)
    end

    describe "#tasks_completed_by_day_as_json" do
      shared_examples "tasks_completed_by_day_as_json" do
        it "returns an array of size 365" do
          subject.tasks_completed_by_day_as_json.should be_a(Array)
          subject.tasks_completed_by_day_as_json.size.should == 365
        end

        it "formats dates in YYYY-MM-DD format" do
          subject.tasks_completed_by_day_as_json.each do |day|
            day[:date].should match(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/)
          end
        end

        it "has a count of >= 0 for each day" do
          subject.tasks_completed_by_day_as_json.each do |day|
            day[:count].should be >= 0
          end
        end
      end

      context "user has no tasks" do
        subject { user }

        it_behaves_like "tasks_completed_by_day_as_json"

        it "has a count of 0 for every day" do
          subject.tasks_completed_by_day_as_json.each do |day|
            day[:count].should == 0
          end
        end
      end

      context "user has tasks" do
        subject { user_with_tasks }

        it_behaves_like "tasks_completed_by_day_as_json"

        it "has the correct counts for days on which tasks were completed" do
          json = subject.tasks_completed_by_day_as_json
          json[-1][:count].should == 2
          json[-3][:count].should == 1
        end
      end
    end

    describe "#tasks_completed_by_day" do
      context "user has no tasks" do
        subject { user }

        it "returns an empty hash" do
          subject.send(:tasks_completed_by_day).should == {}
        end
      end

      context "user has tasks" do
        subject { user_with_tasks }

        it "returns the expected array of completed tasks" do
          subject.send(:tasks_completed_by_day).should == {
            "#{3.days.ago.strftime("%Y-%m-%d")}" => 1,
            "#{1.day.ago.strftime("%Y-%m-%d")}" => 2,
          }
        end
      end
    end
  end
end

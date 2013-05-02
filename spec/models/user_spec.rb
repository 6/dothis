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

  describe "#tasks_completed_by_day" do
    let(:user) { FactoryGirl.create(:user) }

    context "user has no tasks" do
      it "returns an empty array" do
        user.tasks_completed_by_day.should == []
      end
    end

    context "user has tasks" do
      before do
        user.tasks.create!(title: "incomplete task")
        user.tasks.create!(title: "completed 1 day ago", completed_at: 1.day.ago)
        user.tasks.create!(title: "completed 1 day ago", completed_at: 1.day.ago)
        user.tasks.create!(title: "completed 3 days ago", completed_at: 3.days.ago)
      end

      it "returns the expected array of completed tasks" do
        user.tasks_completed_by_day.should == [
          {date: "#{3.days.ago.strftime("%Y-%m-%d")}", count: 1},
          {date: "#{1.day.ago.strftime("%Y-%m-%d")}", count: 2}
        ]
      end
    end
  end
end

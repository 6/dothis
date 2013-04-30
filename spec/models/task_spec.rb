require 'spec_helper'

describe Task do
  it_behaves_like "a FactoryGirl class"

  let(:user) { FactoryGirl.create(:user) }

  describe "#create!" do
    it "fails if the title is not present" do
      expect { user.tasks.create!(title: "") }.to raise_error(ActiveRecord::RecordInvalid, /Title is too short/)
    end

    context "with valid params" do
      it "creates a new Task" do
        expect { user.tasks.create!(title: "valid title") }.to change { Task.count }.by(1)
      end

      it "sets the expected field values on Task" do
        user.tasks.create!(title: "valid title")
        user.tasks.last.tap do |t|
          t.user_id.should == user.id
          t.title.should == "valid title"
        end
      end
    end
  end
end

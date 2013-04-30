require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "renders the :new template" do
      get :new
      response.should render_template(:new)
    end

    context "user is already logged in" do
      before(:each) { controller.stub(:current_user).and_return(true) }

      it "redirects to root_url" do
        get :new
        response.should redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      def go!
        post :create, user: FactoryGirl.attributes_for(:user)
      end

      it "creates a User" do
        expect{ go! }.to change { User.count }.by(1)
      end

      it "redirects to the home page" do
        go!
        response.should redirect_to root_url
      end

      it "assumes 'remember me'" do
        ActionDispatch::Cookies::PermanentCookieJar.should_receive(:new) { {} }
        go!
      end

      context "user is already logged in" do
        before(:each) { controller.stub(:current_user).and_return(true) }

        it "does not create a User" do
          expect { go! }.not_to change { User.count }
        end

        it "redirects to root url" do
          go!
          response.should redirect_to root_url
        end
      end
    end

    context "with invalid attributes" do
      def go!
        post :create, user: {email: "pg.com", password: "abcdef"}
      end

      it "does not create a User" do
        expect{ go! }.not_to change { User.count }
      end

      it "re-renders the :new template" do
        go!
        response.should render_template(:new)
      end

      context "user is already logged in" do
        before(:each) { controller.stub(:current_user).and_return(true) }

        it "redirects to root url" do
          go!
          response.should redirect_to root_url
        end
      end
    end
  end
end

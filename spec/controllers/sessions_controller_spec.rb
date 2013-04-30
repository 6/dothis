require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    it "renders the :new template" do
      get :new
      response.should render_template(:new)
    end

    context "user is already logged in" do
      before(:each) { controller.stub(:current_user).and_return(true) }

      it "redirects to root url" do
        get :new
        response.should redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    shared_examples "sessions#create with valid authentication" do
      it "logs in the User" do
        go!
        cookies[:auth_token].should == User.last.auth_token
      end

      it "redirects to root_url" do
        go!
        response.should redirect_to root_url
      end

      it "uses a non-permanent remember me cookie by default" do
        ActionDispatch::Cookies::PermanentCookieJar.should_not_receive(:new)
        go!
      end

      it "sets a permantent remember me cookie if checked" do
        ActionDispatch::Cookies::PermanentCookieJar.should_receive(:new) { {} }
        go!(remember_me: true)
      end

      context "user is already logged in" do
        before(:each) { controller.stub(:current_user).and_return(true) }

        it "redirects to root url" do
          go!
          response.should redirect_to root_url
        end
      end
    end

    shared_examples "sessions#create with invalid authentication" do
      it "does not login the User" do
        go!
        cookies[:auth_token].should be_nil
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

    context "with valid email authentication" do
      before do
        FactoryGirl.create(:user, email: "p@g.com", password: "abcdef")
      end

      def go!(options = {})
        post :create, {email_or_username: "p@g.com", password: "abcdef", remember_me: options[:remember_me] || ""}
      end

      it_behaves_like "sessions#create with valid authentication"
    end

    context "with valid username authentication" do
      before do
        FactoryGirl.create(:user, username: "peter", password: "abcdef")
      end

      def go!(options = {})
        post :create, {email_or_username: "peter", password: "abcdef", remember_me: options[:remember_me] || ""}
      end

      it_behaves_like "sessions#create with valid authentication"
    end

    context "with invalid email authentication" do
      before do
        FactoryGirl.create(:user, email: "p@g.com", password: "abcdef")
      end

      def go!
        post :create, {email_or_username: "p@g.com", password: "invalid"}
      end

      it_behaves_like "sessions#create with invalid authentication"
    end

    context "with invalid username authentication" do
      before do
        FactoryGirl.create(:user, username: "peter", password: "abcdef")
      end

      def go!
        post :create, {email_or_username: "peter", password: "invalid"}
      end

      it_behaves_like "sessions#create with invalid authentication"
    end
  end

  describe "GET #destroy" do
    it "resets the session" do
      session[:what] = "wut"
      get :destroy
      session[:what].should be_nil
    end

    it "resets the cookies" do
      cookies[:auth_token] = "wut"
      get :destroy
      cookies[:auth_token].should be_nil
    end

    it "redirects to root_url" do
      get :destroy
      response.should redirect_to root_url
    end
  end
end

class SessionsController < ApplicationController
  def new
    logged_out!
  end

  def create
    logged_out!
    @user = User.find_by_email(params[:email_or_username])
    @user ||= User.find_by_username(params[:email_or_username])
    if @user.try(:authenticate, params[:password])
      login_user(@user, remember_me: params[:remember_me].present?)
    else
      flash.now[:error] = "Invalid credentials"
      render :action => "new"
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to root_url
  end
end

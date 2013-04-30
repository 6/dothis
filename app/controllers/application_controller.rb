class ApplicationController < ActionController::Base
  protect_from_forgery

  class AccessDenied < StandardError
  end
  rescue_from AccessDenied, :with => :access_denied

  def login_user(user, options = {})
    reset_session_and_cookies
    if options[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    # TODO - redirect to URL they came from
    redirect_to root_url
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token])  if cookies[:auth_token]
  end
  helper_method :current_user

  def reset_session_and_cookies
    reset_session
    cookies[:auth_token] = nil
  end

  def logged_in!
    raise AccessDenied  unless current_user
  end

  def logged_out!
    raise AccessDenied  if current_user
  end

  def access_denied
    if current_user
      return redirect_to root_url
    else
      return redirect_to login_path
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    render text: "404 not found", status: 404
  end
end

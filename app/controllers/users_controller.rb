class UsersController < ApplicationController
  def index
    # TODO
  end

  def show
    # TODO
  end

  def new
    logged_out!
    @user = User.new
  end

  def create
    logged_out!
    @user = User.new(params[:user])
    if @user.save
      login_user(@user, remember_me: true)
    else
      render :action => "new"
    end
  end
end

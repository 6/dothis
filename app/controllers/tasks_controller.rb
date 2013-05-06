class TasksController < ApplicationController
  respond_to :html, :json

  def index
    respond_with(@tasks = current_user.tasks)
  end

  def show
    respond_with(@task = current_user.tasks.find(params[:id]))
  end

  def create
    respond_with(@task = current_user.tasks.create!(params[:task]), location: nil)
  end

  def update
    respond_with(@task = current_user.tasks.find(params[:id]).update_from_backbone_params(params))
  end

  def destroy
    respond_with(@task = current_user.tasks.find(params[:id]).destroy)
  end
end

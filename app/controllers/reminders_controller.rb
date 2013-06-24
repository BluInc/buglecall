class RemindersController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :html, :json

  def index
    @user = User.find params[:user_id]
    respond_with @user.reminders
  end

  def show
  end

  def create
    
    @user = User.find params[:user_id]
    if @user
      @reminder = Reminder.new params[:reminder]
      @reminder.user_id = @user.id
      if @reminder.save
        respond_with @reminder
        return
      else
        respond_with @reminder, status: 422
        return
      end
    else
      respond_with params[:reminder], status: 422
      return
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

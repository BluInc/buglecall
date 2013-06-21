class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def history
  end

  def create
  end  

  def new
  end

  def edit
    # authorize! :update, User
    @user = User.find(params[:id])
    # authorize! :update, @user  
    respond_with @user
  end

  def update
    # authorize! :update, User
    @user = User.find(params[:id])
    # authorize! :update, @user 
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)
    end
    
    params[:user].delete "created_at" if params[:user].has_key? "created_at"
    params[:user].delete "updated_at" if params[:user].has_key? "updated_at"
    params[:user].delete "id" if params[:user].has_key? "id"
    
    # @user.attributes = remove_password_from_params params[:user]
    if @user.valid?
      @user[:email] = params[:user][:email]
      @user.save
      respond_with @user 
      return
    end  
    respond_with @user, status: 422
  end

  def destroy
    authorize! :destroy, User
    @user = User.find(params[:id])
    authorize! :destroy, @user 
    if @user.destroy
      respond_with @user
      return
    else
      respond_with @user, status: 424
      return
    end  
  end

  def index
    authorize! :read, User
    @users = User.all
    respond_with @users
  end  

  def show
    authorize! :read, User
    @user = User.find(params[:id])
    authorize! :read, @user 
    respond_with @user
  end 

 
end

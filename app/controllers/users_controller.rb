class UsersController < ApplicationController
	def index
		@users = User.paginate(page: params[:page])
	end

	def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
end
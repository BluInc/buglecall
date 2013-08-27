class MicropostsController < ApplicationController
  # before_action :signed_in_user
  #include ActiveModel::ForbiddenAttributesProtection

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'layouts/pages/index'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
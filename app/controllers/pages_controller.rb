class PagesController < ApplicationController
  before_filter :authenticate_user! #Devise forces the user to be authenticated first.
  #load_and_authorize_resource :only => [:index, :show] #cancan support for restful resources

  def index
  	if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  	#render action: "index"
  end
  
end
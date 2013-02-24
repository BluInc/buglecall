class PagesController < ApplicationController
  before_filter :authenticate_user!
  #load_and_authorize_resource :only => [:index, :show] #cancan support for restful resources

  def index
  	if can? :read, PagesController
  	  render action: "index"
  	else
  		flash[:msg] = 'You do not have access to index action'
  	end
  end
  
end
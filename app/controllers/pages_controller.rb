class PagesController < ApplicationController
  before_filter :authenticate_user! #Devise forces the user to be authenticated first.
  #load_and_authorize_resource :only => [:index, :show] #cancan support for restful resources

  def index
  	# Example of using cancan
  	if can? :read, PagesController
  	  render action: "index"

  	else
  		flash[:msg] = 'You do not have access to index action'
  	end
  end
  
end
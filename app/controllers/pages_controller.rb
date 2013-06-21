class PagesController < ApplicationController
  before_filter :authenticate_user! #Devise forces the user to be authenticated first.
  #load_and_authorize_resource :only => [:index, :show] #cancan support for restful resources

  def index
  	render action: "index"
  end
  
end
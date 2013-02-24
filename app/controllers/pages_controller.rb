class PagesController < ApplicationController
  before_filter :authenticate_user!
  #load_and_authorize_resource #cancan support for restful resources

  def index
  	render action: "index"
  end
  
end
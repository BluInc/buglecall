class PagesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  	render action: "index"
  end
  
end
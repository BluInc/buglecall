class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
  	render action: "index"
  end
  
end
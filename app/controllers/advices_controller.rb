class AdvicesController < ApplicationController
	before_filter :authenticate_user!
	layout "food_links_menu"
	
  def new
  end
end

class AdvicesController < ApplicationController
	before_filter :authenticate_user!
	layout "food_links_menu"
	
  def new
  	@course = current_user.courses.availabled.shuffle.first
  end
end

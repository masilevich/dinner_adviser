class AdvicesController < ApplicationController
	before_filter :authenticate_user!
	layout :resolve_layout
	
	def new
		@course = current_user.courses.availabled.shuffle.first
		respond_to do |format|
			format.html
			format.js
		end
	end
end

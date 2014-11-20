class IntroductionController < ApplicationController
	before_filter :authenticate_user!

	include ImportCommon

	def show

	end

	def import_products
		import_common_products
		next_step
	end

	def import_courses
		import_common_courses
		next_step
	end

	def next_step
		if last_step? 
			redirect_to root_path
		else
			redirect_to :action => steps[steps.index(current_step)+1]
		end
	end

	private

	def steps
		%w[show list_common_products list_common_courses]
	end

	def first_step?
  	current_step == steps.first
	end

	def last_step?
  	current_step == steps.last
	end

	def current_step 
		Rails.application.routes.recognize_path(URI(request.referer).path)[:action]
	end
end
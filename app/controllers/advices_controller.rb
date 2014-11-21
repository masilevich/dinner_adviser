class AdvicesController < ApplicationController
	before_filter :authenticate_user!
	layout :resolve_layout
	
	def random_course
		courses = current_user.courses.availabled
		if courses.to_a.count == 1
			@course = courses.first
		elsif courses.to_a.count > 1
			prev_course = current_user.courses.find_by(id: params[:course_id])
			begin

				@course = courses.shuffle.first

			end while prev_course == @course
		end
		respond_to do |format|
			format.html
			format.js
		end
	end
end

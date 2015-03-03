class AdvicesController < ApplicationController
	before_filter :authenticate_user!
	layout :resolve_layout
	before_action :set_courses_from_select, only: [:random_course]
	
	def random_course
		@course_categories = current_user.categories.course_categories
		@selected_course_type = params[:course_type] if params[:course_type]
		@selected_course_category = params[:course_category]  if params[:course_category]

		set_random_course

		respond_to do |format|
			format.html
			format.js
		end
	end

	private

	def set_random_course
		if @courses.to_a.count == 1
			@course = @courses.first
		elsif @courses.to_a.count > 1
			prev_course = current_user.courses.find_by(id: params[:course_id])
			begin
				@course = @courses.shuffle.first
			end while prev_course == @course
		end
	end

	def set_courses_from_select
		@courses = current_user.courses.includes(:products)
		@course_types = {"Доступные для приготовления"=> "1"}
		
		if params[:course_type] && params[:course_type] != ""
			@selected_course_type = params[:course_type]
			course_type = @course_types.key(params[:course_type])
			case @course_types.key(params[:course_type])
			when 'Доступные для приготовления'
				@courses = current_user.courses.availabled
			end
		end

		if params[:course_category] && params[:course_category] != ""
			@courses = @courses.with_category(Category.find(params[:course_category]))
		end
	end

end

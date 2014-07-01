class CourseKindsController < ApplicationController

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
		@course_kinds = current_user.course_kinds
	end

	def create
		@course_kind = current_user.course_kinds.build(course_kind_params)
		save_result = @course_kind.save
		if save_result
			@course_kinds = current_user.course_kinds
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Вид блюда добавлен'
				else
					flash[:danger] = 'Вид блюда не добавлен'
				end
				redirect_to course_kinds_path
			end
			format.js
		end
	end

		def destroy
		delete_result = CourseKind.find(params[:id]).destroy
		if delete_result
			@course_kinds = current_user.course_kinds
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Вид блюда удален'
				else
					flash[:danger] = 'Вид блюда не удален'
				end
				redirect_to course_kinds_path
			end
			format.js
		end
	end

	def edit
		@course_kind = CourseKind.find(params[:id])
	end

	def update
		@course_kind = CourseKind.find(params[:id])
		if @course_kind.update_attributes(course_kind_params)
			flash[:success] = 'Вид блюда изменен'
			redirect_to course_kinds_path
		else
			flash.now[:success] = 'Вид блюда не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def course_kind_params
		params.require(:course_kind).permit(:name, :available)
	end

	def correct_user
		@course_kind = current_user.course_kinds.find_by(id: params[:id])
		redirect_to root_url if @course_kind.nil?
	end

end

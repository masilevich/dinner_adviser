class CourseKindsController < ApplicationController
	layout "food_links_menu"

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
	end

	def create
		@course_kind = current_user.course_kinds.build(course_kind_params)
		respond_to do |format|
			format.html do
				if @course_kind.save
					flash[:success] = 'Вид блюда добавлен'
				else
					flash[:alert] = 'Вид блюда не добавлен'
				end
				redirect_to course_kinds_path
			end
			format.js {@course_kind.save}
		end
	end

		def destroy
		CourseKind.find(params[:id]).destroy
		respond_to do |format|
			format.html do
				flash[:success] = 'Вид блюда удален'
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
			flash[:success] = 'Вид блюда не изменен'
			render 'edit'
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

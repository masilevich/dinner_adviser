	class Admin::CoursesController < Admin::AdminController

		before_action :set_common_courses, only: [:index]

		def show
		end

		def index
		end

		def new
			@course = Course.common.build()
			@ingridient = @course.ingridients.build()
			@common_products = Product.common
		end

		def create
			@course = Course.common.build(course_params)
			if @course.save
				flash[:success] = "Блюдо добавлено"
				redirect_to admin_courses_path
			else
				flash.now[:danger] = 'Блюдо не добавлено'
				@common_products = Product.common
				render 'new', layout: "form_for_food_with_sidebar"
			end
		end

		def destroy
			delete_result = Course.find(params[:id]).destroy
			if delete_result
				set_common_courses
			end
			respond_to do |format|
				format.html do
					if delete_result
						flash[:success] = 'Блюдо удалено'
					else
						flash[:danger] = 'Блюдо не удалено'
					end
					redirect_to admin_courses_path
				end
				format.js
			end
		end

		def edit
			@common_products = Product.common
		end

		def update
			if @course.update_attributes(course_params)
				flash[:success] = 'Блюдо изменено'
				redirect_to admin_courses_path
			else
				flash.now[:danger] = 'Блюдо не изменено'
				@common_products = Product.common
				render 'edit', layout: "form_for_food_with_sidebar"
			end
		end

		private

		def set_common_courses
			@courses = Course.common
		end

		def set_course
			@course = Course.find(params[:id])
		end

		def course_params
			params.require(:course).permit(:name, product_ids: [])
		end

	end

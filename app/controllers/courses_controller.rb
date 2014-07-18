class CoursesController < ApplicationController

  before_filter :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_course, only: [:show, :destroy, :edit, :update]
  before_action :set_course_categories, only: [:new, :edit]
  before_action :set_courses, only: [:index]
  before_action :set_available_courses, only: [:index]
  
  def index
  end

  def new
    @course = courses.build()
    @ingridient = @course.ingridients.build()
    @products = current_user.products
    set_course_categories
  end

  def show
  end

  def create
    @course = courses.build(course_params)
    if @course.save
      flash[:success] = "Блюдо добавлено"
      redirect_to courses_path
    else
      flash.now[:danger] = 'Блюдо не добавлено'
      @products = current_user.products
      set_course_categories
      render 'new', layout: "form_for_food_links_menu"
    end
  end

  def destroy
    delete_result = Course.find(params[:id]).destroy
    if delete_result
      set_courses
      set_available_courses
    end
    respond_to do |format|
      format.html do
        if delete_result
          flash[:success] = 'Блюдо удалено'
        else
          flash[:danger] = 'Блюдо не удалено'
        end
        redirect_to courses_path
      end
      format.js
    end
  end

  def edit
    @products = current_user.products
  end

  def update
    if @course.update_attributes(course_params)
      flash[:success] = 'Блюдо изменено'
      redirect_to courses_path
    else
      flash.now[:success] = 'Блюдо не изменено'
      render 'edit', layout: "form_for_food_links_menu"
    end
  end

  private

  def set_courses
    @courses = courses
  end

  def courses
    current_user.courses
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def set_course_categories
    @course_categories = current_user.categories.course_categories
  end

  def set_available_courses
    @availabled_courses = courses.availabled.includes(:user,:products)
  end

  def course_params
    params.require(:course).permit(:name, :category_id, product_ids: [])
  end

  def correct_user
    @course = current_user.courses.find_by(id: params[:id])
    redirect_to root_url if @course.nil?
  end

end

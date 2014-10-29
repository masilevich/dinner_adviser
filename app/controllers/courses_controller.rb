class CoursesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource
  #before_action :set_course, only: [:show, :destroy, :edit, :update, :add_or_remove_to_menu]
  before_action :set_course_categories, only: [:new, :edit]
  before_action :set_courses, only: [:index, :add_or_remove_to_menu]
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

  def add_or_remove_to_menu
    @course_ids = if params[:course_ids]
      params[:course_ids].map { |i| i.to_i }
    else
      []
    end
    #@course_ids = params[:course_ids] || []  
    if params[:add_to_menu]
      @course_ids << @course.id
    else
      @course_ids.delete(@course.id)
    end
    @courses_in_menu = Course.where(id: @course_ids)

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

end

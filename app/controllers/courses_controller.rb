class CoursesController < ApplicationController

  before_filter :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
  	@courses = current_user.courses.includes(:user,:products)
    @availabled_courses = current_user.courses.availabled.includes(:user,:products)
  end

  def new
    @course = current_user.courses.build()
    @ingridient = @course.ingridients.build()
    @products = current_user.products
    @course_kinds = current_user.course_kinds
  end

  def show
    @course = Course.find(params[:id])
  end

  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      flash[:success] = "Блюдо добавлено"
      redirect_to courses_path
    else
      flash.now[:danger] = 'Блюдо не добавлено'
      @products = current_user.products
      @course_kinds = current_user.course_kinds
      render 'new', layout: "form_for_food_links_menu"
    end
  end

  def destroy
    delete_result = Course.find(params[:id]).destroy
    if delete_result
      @courses = current_user.courses.includes(:user,:products)
      @availabled_courses = current_user.courses.availabled.includes(:user,:products)
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
    @course = Course.find(params[:id])
    @products = current_user.products
    @course_kinds = current_user.course_kinds
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = 'Блюдо изменено'
      redirect_to courses_path
    else
      flash.now[:success] = 'Блюдо не изменено'
      render 'edit', layout: "form_for_food_links_menu"
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :course_kind_id, product_ids: [])
  end

  def correct_user
    @course = current_user.courses.find_by(id: params[:id])
    redirect_to root_url if @course.nil?
  end

end

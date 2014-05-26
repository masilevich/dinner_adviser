class CoursesController < ApplicationController
  layout "food_links_menu"

  before_filter :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
  	@courses = current_user.courses
  end

  def new
    @course = current_user.courses.build()
    @ingridient = @course.ingridients.build()
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
      flash[:alert] = 'Блюдо не добавлено'
      render 'new'
    end
  end

  def destroy
    Course.find(params[:id]).destroy
    respond_to do |format|
      format.html do
        flash[:success] = 'Блюдо удалено'
        redirect_to courses_path
      end
      format.js
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = 'Блюдо изменено'
      redirect_to courses_path
    else
      flash[:success] = 'Блюдо не изменено'
      render 'edit'
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, product_ids: [])
  end

  def correct_user
    @course = current_user.courses.find_by(id: params[:id])
    redirect_to root_url if @course.nil?
  end
end

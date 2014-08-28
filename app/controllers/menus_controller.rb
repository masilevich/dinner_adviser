class MenusController < ApplicationController
	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_menu, only: [:show, :destroy, :edit, :update, :manage_courses]
  before_action :set_menu_categories, only: [:new, :edit]
  before_action :set_menus, only: [:index]

  def new
    @menu = menus.build()
    @courses = current_user.courses.includes(:user,:products)
  end

  def create
    @menu = menus.build(menu_params)
    if @menu.save
      flash[:success] = "Меню добавлено"
      redirect_to menus_path
    else
      flash.now[:danger] = 'Меню не добавлено'
      set_menu_categories
      render 'new', layout: "form_for_food_links_menu"
    end
  end

  def index
  end

  def show
  end

  def destroy
    delete_result = Menu.find(params[:id]).destroy
    if delete_result
      set_menus
    end
    respond_to do |format|
      format.html do
        if delete_result
          flash[:success] = 'Меню удалено'
        else
          flash[:danger] = 'Меню не удалено'
        end
        redirect_to menus_path
      end
      format.js
    end
  end

  def edit
  end

  def update
    if @menu.update_attributes(menu_params)
      flash[:success] = 'Меню изменено'
      redirect_to menus_path
    else
      flash.now[:success] = 'Меню не изменено'
      render 'edit', layout: "form_for_food_links_menu"
    end
  end

  def manage_courses
    @course = Course.find(params[:course_id])
    if @menu.courses.exists?(@course)
      @menu.courses.delete(@course)
    else
      @menu.courses << @course
    end

  end

  private

  def set_menus
    @menus = menus
  end

  def menus
    current_user.menus
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def set_menu_categories
    @menu_categories = current_user.categories.menu_categories
  end

  def menu_params
    params.require(:menu).permit(:date, :category_id)
  end

  def correct_user
    @menu = current_user.menus.find_by(id: params[:id])
    redirect_to root_url if @menu.nil?
  end
end

class MenusController < ApplicationController
	before_filter :authenticate_user!
  load_and_authorize_resource
  #before_action :set_menu, only: [:show, :destroy, :edit, :update, :products]
  before_action :set_menu_categories, only: [:new, :edit]
  before_action :set_menus, only: [:index]
  before_action :check_course_ids_is_string, only: [:create, :update]

  def new
    @menu = menus.build()
    set_courses
    @courses_in_menu = []
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
    set_courses
    @courses_in_menu = @menu.courses
    @course_ids = @courses_in_menu.ids
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

  def products
    @enough_products = @menu.products.enough
    @not_enough_products = @menu.products.not_enough
  end


  private

  def check_course_ids_is_string
    params[:menu][:course_ids] = view_context.check_params_ids_is_string(params, :menu, :course_ids)
  end

  def set_menus
    @menus = menus.includes(:category)
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

  def set_courses
    @courses = current_user.courses 
  end

  def menu_params
    params.require(:menu).permit(:date, :category_id, course_ids: [])
  end

end

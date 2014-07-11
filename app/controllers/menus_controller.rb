class MenusController < ApplicationController
	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @menu = current_user.menus.build()
    @menu_kinds = current_user.menu_kinds
    @courses = current_user.courses.includes(:user,:products)
  end

  def create
    @menu = current_user.menus.build(menu_params)
    if @menu.save
      flash[:success] = "Меню добавлено"
      redirect_to menus_path
    else
      flash.now[:danger] = 'Меню не добавлено'
      @menu_kinds = current_user.menu_kinds
      render 'new', layout: "form_for_food_links_menu"
    end
  end

  def index
    @menus = current_user.menus
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def destroy
    delete_result = Menu.find(params[:id]).destroy
    if delete_result
      @menus = current_user.menus
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
    @menu = Menu.find(params[:id])
    @menu_kinds = current_user.menu_kinds
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(menu_params)
      flash[:success] = 'Меню изменено'
      redirect_to menus_path
    else
      flash.now[:success] = 'Меню не изменено'
      render 'edit', layout: "form_for_food_links_menu"
    end
  end

  def menu_params
    params.require(:menu).permit(:date, :menu_kind_id)
  end

  def correct_user
    @menu = current_user.menus.find_by(id: params[:id])
    redirect_to root_url if @menu.nil?
  end
end

class MenuKindsController < ApplicationController
	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
		@menu_kinds = current_user.menu_kinds
	end

	def create
		@menu_kind = current_user.menu_kinds.build(menu_kind_params)
		save_result = @menu_kind.save
		if save_result
			@menu_kinds = current_user.menu_kinds
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Вид меню добавлен'
				else
					flash[:danger] = 'Вид меню не добавлен'
				end
				redirect_to menu_kinds_path
			end
			format.js 
		end
	end

	def destroy
		delete_result = MenuKind.find(params[:id]).destroy
		if delete_result
			@menu_kinds = current_user.menu_kinds
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Вид меню удален'
				else
					flash[:danger] = 'Вид меню не удален'
				end
				redirect_to menu_kinds_path
			end
			format.js
		end
	end

	def edit
		@menu_kind = MenuKind.find(params[:id])
	end

	def update
		@menu_kind = MenuKind.find(params[:id])
		if @menu_kind.update_attributes(menu_kind_params)
			flash[:success] = 'Вид меню изменен'
			redirect_to menu_kinds_path
		else
			flash.now[:success] = 'Вид меню не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def menu_kind_params
		params.require(:menu_kind).permit(:name, :available)
	end

	def correct_user
		@menu_kind = current_user.menu_kinds.find_by(id: params[:id])
		redirect_to root_url if @menu_kind.nil?
	end
	
end

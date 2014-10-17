class ShoppingListsController < ApplicationController
	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]
	before_action :set_shopping_list, only: [:show, :edit, :update, :destroy]
	before_action :set_shopping_lists, only: [:index]

	def index
	end

	 def show
  end

	def new
		@shopping_list = shopping_lists.build()
	end

	def create
		@shopping_list = shopping_lists.build(shopping_list_params)
		save_result = @shopping_list.save
		if save_result
			set_shopping_lists
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Список покупок добавлен'
					redirect_to shopping_lists_path
				else
					flash.now[:danger] = 'Список покупок не добавлен'
					render 'new', layout: "form_for_food_links_menu"
				end
			end
			format.js
		end
	end

	def destroy
		delete_result = ShoppingList.find(params[:id]).destroy
		if delete_result
			set_shopping_lists
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Список покупок удален'
				else
					flash[:danger] = 'Список покупок не удален'
				end
				redirect_to shopping_lists_path
			end
			format.js
		end
	end


	def edit
	end

	def update
		if @shopping_list.update_attributes(shopping_list_params)
			flash[:success] = 'Список покупок изменен'
			redirect_to shopping_lists_path
		else
			flash.now[:success] = 'Список покупок не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def set_shopping_lists
		@shopping_lists = shopping_lists
	end

	def shopping_lists
		current_user.shopping_lists
	end

	def set_shopping_list
		@shopping_list = ShoppingList.find(params[:id])
	end

	def shopping_list_params
		params.require(:shopping_list).permit(:name)
	end

	def correct_user
		@shopping_list = current_user.shopping_lists.find_by(id: params[:id])
		redirect_to root_url if @shopping_list.nil?
	end
end

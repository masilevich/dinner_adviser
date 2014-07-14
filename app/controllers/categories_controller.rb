class CategoriesController < ApplicationController

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
		@categories = current_user.categories
	end

	def create
		@product_kind = current_user.product_kinds.build(product_kind_params)
		save_result = @product_kind.save
		if save_result
			@product_kinds = current_user.product_kinds
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Вид продуктов добавлен'
				else
					flash[:danger] = 'Вид продуктов не добавлен'
				end
				redirect_to product_kinds_path
			end
			format.js 
		end
	end

	private

	def category_params
		params.require(:category).permit(:name)
	end

	def correct_user
		@category = current_user.categories.find_by(id: params[:id])
		redirect_to root_url if @category.nil?
	end
end

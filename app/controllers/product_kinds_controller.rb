class ProductKindsController < ApplicationController

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
		@product_kinds = current_user.product_kinds
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

	def destroy
		delete_result = ProductKind.find(params[:id]).destroy
		if delete_result
			@product_kinds = current_user.product_kinds
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Вид продуктов удален'
				else
					flash[:danger] = 'Вид продуктов не удален'
				end
				redirect_to product_kinds_path
			end
			format.js
		end
	end

	def edit
		@product_kind = ProductKind.find(params[:id])
	end

	def update
		@product_kind = ProductKind.find(params[:id])
		if @product_kind.update_attributes(product_kind_params)
			flash[:success] = 'Вид продуктов изменен'
			redirect_to product_kinds_path
		else
			flash.now[:success] = 'Вид продуктов не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def product_kind_params
		params.require(:product_kind).permit(:name, :available)
	end

	def correct_user
		@product_kind = current_user.product_kinds.find_by(id: params[:id])
		redirect_to root_url if @product_kind.nil?
	end
end

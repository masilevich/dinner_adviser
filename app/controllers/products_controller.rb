class ProductsController < ApplicationController
	layout "food_links_menu"

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy, :set_availability]

	def index
		@products = current_user.products.includes(:user)
		@available_products = current_user.products.availabled.includes(:user)
	end

	def create
		@product = current_user.products.build(product_params)
		respond_to do |format|
			format.html do
				if @product.save
					flash[:success] = 'Продукт добавлен'
				else
					flash[:alert] = 'Продукт не добавлен'
				end
				redirect_to products_path
			end
			format.js {@product.save}
		end
	end

	def destroy
		Product.find(params[:id]).destroy
		respond_to do |format|
			format.html do
				flash[:success] = 'Продукт удален'
				redirect_to products_path
			end
			format.js
		end
	end

	def set_availability
		@product = Product.find(params[:id])
		if params[:available] then
			available = params[:available]
		else
			available = false
		end
		if @product.update_attribute(:available, available)
			respond_to do |format|
				format.html do
					if @product.available?
						flash[:success] = 'Продукт доступен'
					end
					redirect_to products_path
				end
				format.js do
					case URI(request.referer).path
					when "/products"
						@products = current_user.products
						@available_products = current_user.products.availabled
					when "/courses"
						@courses = current_user.courses
						@availabled_courses = current_user.courses.availabled
					end

				end
			end
		end
	end

	def edit
		@product = Product.find(params[:id])
	end

	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(product_params)
			flash[:success] = 'Продукт изменен'
			redirect_to products_path
		else
			flash[:success] = 'Продукт не изменен'
			render 'edit'
		end
	end

	private

	def product_params
		params.require(:product).permit(:name, :available)
	end

	def correct_user
		@product = current_user.products.find_by(id: params[:id])
		redirect_to root_url if @product.nil?
	end
end

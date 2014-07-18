class ProductsController < ApplicationController

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy, :set_availability]
	before_action :set_product, only: [:edit, :update, :destroy, :set_availability]
	before_action :set_product_categories, only: [:new, :edit]
	before_action :set_products, only: [:index]
	before_action :set_available_products, only: [:index]

	def index
	end

	def new
		@product = products.build()
	end

	def create
		@product = products.build(product_params)
		save_result = @product.save
		if save_result
			set_products
			set_available_products
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Продукт добавлен'
					redirect_to products_path
				else
					flash.now[:danger] = 'Продукт не добавлен'
					set_product_categories
					render 'new', layout: "form_for_food_links_menu"
				end
			end
			format.js
		end
	end

	def destroy
		delete_result = Product.find(params[:id]).destroy
		if delete_result
			set_products
			set_available_products
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Продукт удален'
				else
					flash[:danger] = 'Продукт не удален'
				end
				redirect_to products_path
			end
			format.js
		end
	end

	def set_availability
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
						set_products
						set_available_products
					when "/courses"
						@courses = current_user.courses
						@availabled_courses = current_user.courses.availabled
					end
				end
			end
		end
	end

	def edit
	end

	def update
		if @product.update_attributes(product_params)
			flash[:success] = 'Продукт изменен'
			redirect_to products_path
		else
			flash.now[:success] = 'Продукт не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def set_products
		@products = products
	end

	def products
		current_user.products
	end

	def set_available_products
		@available_products = current_user.products.availabled.includes(:user)
	end

	def set_product
		@product = Product.find(params[:id])
	end

	def set_product_categories
		@product_categories = current_user.categories.product_categories
	end

	def product_params
		params.require(:product).permit(:name, :available, :category_id)
	end

	def correct_user
		@product = current_user.products.find_by(id: params[:id])
		redirect_to root_url if @product.nil?
	end

end

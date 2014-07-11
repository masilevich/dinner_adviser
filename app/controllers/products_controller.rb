class ProductsController < ApplicationController

	before_filter :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy, :set_availability]

	def index
		@products = current_user.products.includes(:user)
		@available_products = current_user.products.availabled.includes(:user)
	end

	def new
		@product = current_user.products.build()
		@product_kinds = current_user.product_kinds
	end

	def create
		@product = current_user.products.build(product_params)
		save_result = @product.save
		if save_result
			@products = current_user.products.includes(:user)
			@available_products = current_user.products.availabled.includes(:user)
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = 'Продукт добавлен'
					redirect_to products_path
				else
					flash.now[:danger] = 'Продукт не добавлен'
					@product_kinds = current_user.product_kinds
					render 'new', layout: "form_for_food_links_menu"
				end
			end
			format.js
		end
	end

	def destroy
		delete_result = Product.find(params[:id]).destroy
		if delete_result
			@products = current_user.products.includes(:user)
			@available_products = current_user.products.availabled.includes(:user)
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
		@product_kinds = current_user.product_kinds
	end

	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(product_params)
			flash[:success] = 'Продукт изменен'
			redirect_to products_path
		else
			flash.now[:success] = 'Продукт не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	private

	def product_params
		params.require(:product).permit(:name, :available, :product_kind_id)
	end

	def correct_user
		@product = current_user.products.find_by(id: params[:id])
		redirect_to root_url if @product.nil?
	end

end

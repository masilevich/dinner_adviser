class ProductsController < ApplicationController
	
	before_filter :authenticate_user!
	load_and_authorize_resource
	#before_action :set_product, only: [:show, :edit, :update, :destroy, :add_or_remove_to_shopping_list]
	before_action :set_product_categories, only: [:new, :edit]
	before_action :set_products, only: [:index, :add_or_remove_to_shopping_list, :import_common]
	before_action :set_available_products, only: [:index]

	include ImportCommon

	def show
	end

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
					case Rails.application.routes.recognize_path(URI(request.referer).path)[:controller]
					when "products"
						set_products
						set_available_products
					when "courses"
						@courses = current_user.courses
						@availabled_courses = current_user.courses.availabled
					when "menus"
						menu_id = Rails.application.routes.recognize_path(URI(request.referer).path)[:id]
						@menu = Menu.find(menu_id)
						@enough_products = @menu.products.enough
						@not_enough_products = @menu.products.not_enough
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
			flash.now[:danger] = 'Продукт не изменен'
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	def add_or_remove_to_shopping_list
		@product_ids = if params[:product_ids]
			params[:product_ids].map { |i| i.to_i }
		else
			[]
		end 
		if params[:add_to_shopping_list]
			@product_ids << @product.id
		else
			@product_ids.delete(@product.id)
		end
		@products_in_shopping_list = Product.where(id: @product_ids)

	end

	def list_common
		list_common_products
	end

	def import_common
		import_common_products do |imported_products_number|
			if imported_products_number > 0 
				flash[:success] = "Продуктов импортировано: #{imported_products_number}"
			end
		end
		redirect_to products_path
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

end

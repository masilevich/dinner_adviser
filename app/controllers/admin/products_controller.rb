	class Admin::ProductsController < Admin::AdminController

		before_action :set_common_products, only: [:index]

		def show
		end

		def index
		end

		def new
			@product = Product.common.build()
		end

		def create
			@product = Product.common.build(product_params)
			save_result = @product.save
			if save_result
				set_common_products
			end
			respond_to do |format|
				format.html do
					if save_result
						flash[:success] = 'Продукт добавлен'
						redirect_to admin_products_path
					else
						flash.now[:danger] = 'Продукт не добавлен'
						render 'new', layout: "form_for_food_links_menu"
					end
				end
				format.js
			end
		end

		def destroy
			delete_result = Product.find(params[:id]).destroy
			if delete_result
				set_common_products
			end
			respond_to do |format|
				format.html do
					if delete_result
						flash[:success] = 'Продукт удален'
					else
						flash[:danger] = 'Продукт не удален'
					end
					redirect_to admin_products_path
				end
				format.js
			end
		end

		def edit
		end

		def update
			if @product.update_attributes(product_params)
				flash[:success] = 'Базовый продукт изменен'
				redirect_to admin_products_path
			else
				flash.now[:danger] = 'Базовый продукт не изменен'
				render 'edit', layout: "form_for_food_links_menu"
			end
		end

		private

		def set_common_products
			@products = Product.common
		end

		def set_product
			@product = Product.find(params[:id])
		end

		def product_params
			params.require(:product).permit(:name, :common)
		end

	end

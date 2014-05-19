class ProductsController < ApplicationController
	layout "food_links_menu"

	def index
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
		if params[:product][:available] then
			if @product.update_attribute(:available, params[:product][:available])
				respond_to do |format|
					format.html do
						if @product.available?
							flash[:success] = 'Продукт доступен'
						end
						redirect_to products_path
					end
					format.js
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
end

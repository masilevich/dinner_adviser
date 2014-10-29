class CategoriesController < ApplicationController

	before_filter :authenticate_user!
  load_and_authorize_resource
	#before_action :set_category, only: [:edit, :update, :destroy]
	before_action :set_type
	before_action :set_ru_type_pluralize, only: [:edit, :update, :create, :index]


	def index
		@categories = categories
	end

	def edit
	end

	def update
		if @category.update_attributes(category_params)
			flash[:success] = "Вид #{@ru_type_pluralize} изменен"
			redirect_to polymorphic_path(type_class)
		else
			flash.now[:success] = "Вид #{@ru_type_pluralize} не изменен"
			render 'edit', layout: "form_for_food_links_menu"
		end
	end

	def create
		@category = categories.build(category_params)
		save_result = @category.save
		if save_result
			@categories = categories
		end
		respond_to do |format|
			format.html do
				if save_result
					flash[:success] = "Вид #{@ru_type_pluralize} добавлен"
				else
					flash[:danger] = "Вид #{@ru_type_pluralize} не добавлен"
				end
				redirect_to polymorphic_path(type_class)
			end
			format.js 
		end
	end

	def destroy
		delete_result = @category.destroy
		if delete_result
			@categories = categories
		end
		respond_to do |format|
			format.html do
				if delete_result
					flash[:success] = 'Вид #{@ru_type_pluralize} удален'
				else
					flash[:danger] = 'Вид #{@ru_type_pluralize} не удален'
				end
				redirect_to polymorphic_path(type_class)
			end
			format.js
		end
	end

	private

	def set_type 
		@type = type 
	end

	def type 
		Category.types.include?(params[:type]) ? params[:type] : "Category"
	end

	def type_class 
		type.constantize
	end

	def set_category
		@category = type_class.find(params[:id])
	end

	def categories
		if @type == "Category"
			current_user.categories
		else
			current_user.categories.send(type.tableize)
		end
	end

	def category_params
		params.require(:"#{type.underscore}").permit(:name, :type)
	end

	def set_ru_type_pluralize
		@ru_type_pluralize = case type
		when "ProductCategory"
			"продуктов"
		when "CourseCategory"
			"блюд"
		when "MenuCategory"
			"меню"
		end
	end

end

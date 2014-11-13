class Admin::AdminController < ApplicationController 
	before_filter :authenticate_user!
	load_and_authorize_resource

	layout :resolve_layout

	def index
	end

	def resolve_layout
		case action_name
		when "new" , "edit" , "show"
			"admin_form_for_food_links_menu"
		else 
			"admin_food_links_menu"
		end
	end

	protected
end
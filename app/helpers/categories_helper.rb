module CategoriesHelper
	def sti_category_path(type = "category", category = nil, action = nil)
		send "#{format_sti(action, type, category)}_path", category
	end

	def format_sti(action, type, category)
		action || category ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
	end

	def format_action(action)
		action ? "#{action}_" : ""
	end
end

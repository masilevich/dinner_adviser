module MenusHelper
	def menu_name(menu)
    "#{menu.category ? (menu.category.name) + " " : ""}на #{menu.date}"
  end
end

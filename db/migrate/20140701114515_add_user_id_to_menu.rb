class AddUserIdToMenu < ActiveRecord::Migration
  def change
  	add_column :menu_kinds, :user_id, :integer
  	add_column :menus, :user_id, :integer
  end
end

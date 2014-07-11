class AddIndexToMenuMenuKindProduct < ActiveRecord::Migration
  def change
  	add_index :menus, [:user_id]

    add_index :menu_kinds, [:user_id]
    add_index :menu_kinds, [:name, :user_id ], unique: true

    add_index :product_kinds, [:user_id]
    add_index :product_kinds, [:name, :user_id ], unique: true
  end
end

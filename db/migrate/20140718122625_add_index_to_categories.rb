class AddIndexToCategories < ActiveRecord::Migration
  def change
  	add_index :categories, [:user_id]
    add_index :categories, [:name, :type, :user_id ], unique: true
  end
end

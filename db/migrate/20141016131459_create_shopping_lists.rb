class CreateShoppingLists < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end

    add_index :shopping_lists, [:user_id, :name]
  end
end

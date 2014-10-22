class CreateProductsShoppingListsJoinTable < ActiveRecord::Migration
  def change
    create_table :products_shopping_lists, id: false do |t|
      t.integer :product_id
      t.integer :shopping_list_id
    end
 
    add_index :products_shopping_lists, :product_id
    add_index :products_shopping_lists, :shopping_list_id
  end
end

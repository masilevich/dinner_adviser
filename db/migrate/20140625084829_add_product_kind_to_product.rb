class AddProductKindToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :product_kind_id, :integer
  end
end

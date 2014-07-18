class RenameKindToCategoryInProducts < ActiveRecord::Migration
  def change
  	rename_column :products, :product_kind_id, :category_id
  end
end

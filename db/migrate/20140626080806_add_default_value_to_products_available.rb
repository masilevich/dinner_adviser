class AddDefaultValueToProductsAvailable < ActiveRecord::Migration
  def change
  	change_column :products, :available, :boolean, :default => false, :null => false
  end
end

class AddAvailableToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :available, :boolean
  end
end

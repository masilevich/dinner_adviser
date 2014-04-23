class RenameCompositionsToIngridients < ActiveRecord::Migration
  def change
  	rename_table :compositions, :ingridients
  end
end

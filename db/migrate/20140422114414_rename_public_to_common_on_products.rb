class RenamePublicToCommonOnProducts < ActiveRecord::Migration
  def change
  	rename_column :products, :public, :common
  end
end

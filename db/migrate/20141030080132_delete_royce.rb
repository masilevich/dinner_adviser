class DeleteRoyce < ActiveRecord::Migration
  def change
  	drop_table :royce_role
  	drop_table :royce_connector
  end
end

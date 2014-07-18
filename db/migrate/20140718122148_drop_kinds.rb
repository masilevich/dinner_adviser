class DropKinds < ActiveRecord::Migration
  def change
  	drop_table :product_kinds
  	drop_table :menu_kinds
  	drop_table :course_kinds
  end
end

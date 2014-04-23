class CreateCompositions < ActiveRecord::Migration
  def change
    create_table :compositions do |t|
      t.integer :course_id
      t.integer :product_id
      t.integer :weight

      t.timestamps
    end
  end
end

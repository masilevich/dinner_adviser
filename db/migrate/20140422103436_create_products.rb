class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :public
      t.integer :user_id
      t.timestamps
    end

    add_index :products, [:user_id]
    add_index :products, [:name, :user_id ], unique: true
  end
end

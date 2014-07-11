class CreateMenuKinds < ActiveRecord::Migration
  def change
    create_table :menu_kinds do |t|
      t.string :name

      t.timestamps
    end
  end
end

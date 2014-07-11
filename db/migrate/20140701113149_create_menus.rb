class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.date :date
      t.integer :menu_kind_id

      t.timestamps
    end

    create_table :menus_courses, id: false do |t|
      t.belongs_to :menu
      t.belongs_to :course
    end
  end
end

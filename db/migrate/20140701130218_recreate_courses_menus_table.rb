class RecreateCoursesMenusTable < ActiveRecord::Migration
  def change
  	drop_table :menus_courses

  	create_table :courses_menus, id: false do |t|
      t.belongs_to :course
      t.belongs_to :menu
    end
  end
end

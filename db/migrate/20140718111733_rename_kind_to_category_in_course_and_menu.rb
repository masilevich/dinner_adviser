class RenameKindToCategoryInCourseAndMenu < ActiveRecord::Migration
  def change
  	rename_column :courses, :course_kind_id, :category_id
  	rename_column :menus, :menu_kind_id, :category_id
  end
end

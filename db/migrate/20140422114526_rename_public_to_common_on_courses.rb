class RenamePublicToCommonOnCourses < ActiveRecord::Migration
  def change
  	rename_column :courses, :public, :common
  end
end

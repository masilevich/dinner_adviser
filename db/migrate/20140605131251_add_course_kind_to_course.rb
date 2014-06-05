class AddCourseKindToCourse < ActiveRecord::Migration
  def change
  	add_column :courses, :course_kind_id, :integer
  end
end

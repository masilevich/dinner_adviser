class DropCourseToCourseKindTable < ActiveRecord::Migration
  def change
  	drop_table :course_kinds_courses
  end
end

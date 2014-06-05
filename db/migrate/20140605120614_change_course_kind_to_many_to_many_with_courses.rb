class ChangeCourseKindToManyToManyWithCourses < ActiveRecord::Migration
  def change
  	add_column :course_kinds, :user_id, :integer
  	remove_column :courses, :course_kind_id, :integer

  	create_table :course_kinds_courses, id: false do |t|
      t.belongs_to :course_kind
      t.belongs_to :course
    end
  end
end

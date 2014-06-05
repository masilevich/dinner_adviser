class AddIndexToCourseKind < ActiveRecord::Migration
  def change
  	add_index :course_kinds, [:user_id]
    add_index :course_kinds, [:name, :user_id ], unique: true
  end
end

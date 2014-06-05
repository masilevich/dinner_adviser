class AddUserToCourseKinds < ActiveRecord::Migration
  def change
  	add_column :course_kinds, :user_id, :integer
  end
end

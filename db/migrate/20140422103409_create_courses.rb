class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :course_kind_id
      t.boolean :public
      t.integer :user_id
      t.timestamps
    end

    add_index :courses, [:user_id]
    add_index :courses, [:name, :user_id ], unique: true
  end
end

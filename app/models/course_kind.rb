class CourseKind < ActiveRecord::Base
	has_many :courses
	belongs_to :user

	default_scope {order('name ASC')}

	validates :name, presence: true, length: {maximum: 50}
end

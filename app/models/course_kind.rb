class CourseKind < ActiveRecord::Base
	has_many :courses

	validates :name, presence: true, length: {maximum: 50}
end

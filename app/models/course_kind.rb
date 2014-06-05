class CourseKind < ActiveRecord::Base
	has_many :courses
	belongs_to :user

	validates :name, presence: true, length: {maximum: 50}
end

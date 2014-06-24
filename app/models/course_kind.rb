class CourseKind < ActiveRecord::Base
	has_many :courses
	belongs_to :user

	default_scope {order(name: :asc)}

	validates :name, presence: true, length: {maximum: 50}

	def self.kinds_for_courses(courses)
		self.joins(:courses).where("courses.id IN (?)",courses.select("courses.id")).uniq
	end
end

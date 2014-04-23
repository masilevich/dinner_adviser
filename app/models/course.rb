class Course < ActiveRecord::Base
	belongs_to :user
	belongs_to :course_kind
	has_many :ingridients,  dependent: :destroy
	has_many :products, through: :ingridients

	validates :name, presence: true, length: {maximum: 100}
end

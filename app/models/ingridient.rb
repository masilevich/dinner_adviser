class Ingridient < ActiveRecord::Base
	belongs_to :course
	belongs_to :product

	validates :product_id, presence: true
	validates :course_id, presence: true
end

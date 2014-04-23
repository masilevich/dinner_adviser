class Product < ActiveRecord::Base
	belongs_to :user
	has_many :ingridients
	has_many :courses, through: :ingridients

	validates :name, presence: true, length: {maximum: 100}
end

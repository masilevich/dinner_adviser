class Product < ActiveRecord::Base
	include Categorizable
	belongs_to :user
	has_many :ingridients
	has_many :courses, through: :ingridients

	validates :name, presence: true, length: {maximum: 100}

	default_scope {order(name: :asc)}
	scope :availabled, -> { where(available: true) }

	def self.from_user(user)
		where("user_id = (#{user.id})" )
	end
	
end

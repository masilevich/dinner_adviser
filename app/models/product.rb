class Product < ActiveRecord::Base
	belongs_to :user
	has_many :ingridients
	has_many :courses, through: :ingridients

	default_scope {order('name ASC')}

	validates :name, presence: true, length: {maximum: 100}

	def self.from_user(user)
		where("user_id = (#{user.id})" )
	end
	
end

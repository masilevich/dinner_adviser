class Product < ActiveRecord::Base
	include Categorizable
	belongs_to :user
	has_many :ingridients
	has_many :courses, through: :ingridients
	has_and_belongs_to_many :shopping_lists

	validates :name, presence: true, length: {maximum: 100}

	default_scope {order(name: :asc)}
	scope :availabled, -> { where(available: true) }
	scope :unavailabled, -> { where(available: false) }
	scope :enough, -> { availabled.uniq }
	scope :not_enough, -> { unavailabled.uniq }
	scope :common, -> { where(common: true) }

	scope :commmon_exclude_by_name, 

	def self.from_user(user)
		where("user_id = (#{user.id})" )
	end

	def self.exclude_by_name(products)
		where.not(name: products.pluck(:name))
	end

	def self.common_exclude_by_name(products)
		self.common.merge(self.exclude_by_name(products))
	end

end

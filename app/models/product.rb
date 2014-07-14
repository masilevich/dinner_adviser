class Product < ActiveRecord::Base
	belongs_to :user
	belongs_to :product_kind
	belongs_to :category
	has_many :ingridients
	has_many :courses, through: :ingridients

	validates :name, presence: true, length: {maximum: 100}

	accepts_nested_attributes_for :product_kind,
		:reject_if => proc { |attrs|
			attrs['name'].blank? &&
			attrs['product_kind_id'].blank?
		}

	accepts_nested_attributes_for :category,
		:reject_if => proc { |attrs|
			attrs['name'].blank? &&
			attrs['category_id'].blank?
		}

	default_scope {order(name: :asc)}
	scope :availabled, -> { where(available: true) }

	def self.from_user(user)
		where("user_id = (#{user.id})" )
	end

	scope :without_kind, -> { where(product_kind_id: nil) }
	
end

class ShoppingList < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :products

	accepts_nested_attributes_for :products,
		:reject_if => proc { |attrs|
		attrs['name'].blank? &&
		attrs['product_id'].blank?
	}

	validates :name, presence: true, length: {maximum: 100}
	validates :user_id, presence: true

	default_scope { order(name: :asc) }
end

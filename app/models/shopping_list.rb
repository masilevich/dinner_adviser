class ShoppingList < ActiveRecord::Base
	belongs_to :user

	validates :name, presence: true, length: {maximum: 100}
	validates :user_id, presence: true

	default_scope { order(name: :asc) }
end

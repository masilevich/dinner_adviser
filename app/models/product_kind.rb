class ProductKind < ActiveRecord::Base
	has_many :products
	belongs_to :user

	default_scope {order(name: :asc)}

	validates :name, presence: true, length: {maximum: 50}

	def self.kinds_for_products(products)
		self.joins(:products).where(products: {id: products.pluck("products.id")}).uniq
	end
end

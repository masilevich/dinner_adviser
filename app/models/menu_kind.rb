class MenuKind < ActiveRecord::Base
	has_many :menus
	belongs_to :user

	default_scope {order(name: :asc)}

	validates :name, presence: true, length: {maximum: 50}
end

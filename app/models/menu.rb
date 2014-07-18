class Menu < ActiveRecord::Base
	include Categorizable
	belongs_to :user
	has_and_belongs_to_many :courses

	validates :date, presence: true

	default_scope { order(date: :desc) }
end

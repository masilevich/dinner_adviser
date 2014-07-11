class Menu < ActiveRecord::Base
	belongs_to :user
	belongs_to :menu_kind
	has_and_belongs_to_many :courses

	validates :date, presence: true

	accepts_nested_attributes_for :menu_kind,
	:reject_if => proc { |attrs|
		attrs['menu_kind_id'].blank?
	}

	default_scope { order(date: :desc) }
end

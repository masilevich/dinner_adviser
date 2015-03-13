class Course < ActiveRecord::Base
	include Categorizable
	include Commonable
	belongs_to :user
	has_many :ingridients,  dependent: :destroy
	has_many :products, through: :ingridients
	has_and_belongs_to_many :menus

	validates :name, presence: true, length: {maximum: 100}

	accepts_nested_attributes_for :ingridients,
		allow_destroy: true,
		:reject_if => proc { |attrs|
		attrs['name'].blank? &&
		attrs['product_id'].blank?
	}


	default_scope { order(name: :asc) }

	scope :availabled, -> do
		select('courses.*').joins(:products).group('courses.id')
			.having('(SUM(CASE WHEN products.available = ? then 1 ELSE 0 END)=0)',false)

	end

end

class Course < ActiveRecord::Base
	belongs_to :user
	belongs_to :course_kind
	has_many :ingridients,  dependent: :destroy
	has_many :products, through: :ingridients

	validates :name, presence: true, length: {maximum: 100}

	accepts_nested_attributes_for :ingridients,
		allow_destroy: true,
		:reject_if => proc { |attrs|
			attrs['name'].blank? &&
			attrs['product_id'].blank?
		}

	accepts_nested_attributes_for :course_kind,
		:reject_if => proc { |attrs|
			attrs['name'].blank? &&
			attrs['course_kind_id'].blank?
		}

	default_scope { order(name: :asc) }

	scope :without_kind, -> { where(course_kind_id: nil) }

	scope :availabled, -> do
		joins(:products).group("courses.id").having("(COUNT(CASE WHEN products.available = ? then 1 ELSE null END)=0)",false)
	end

end

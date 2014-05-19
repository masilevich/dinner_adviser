class Ingridient < ActiveRecord::Base
	belongs_to :course
	belongs_to :product

end

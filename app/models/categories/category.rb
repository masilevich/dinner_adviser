class Category < ActiveRecord::Base
	belongs_to :user

	default_scope {order(name: :asc)}

	validates :name, presence: true, length: {maximum: 50}


   def self.types
      %w(ProductCategory MenuCategory CourseCategory)
   end

	self.types.each do |s|
    scope s.tableize, -> {where(type: s)} 
  end


end

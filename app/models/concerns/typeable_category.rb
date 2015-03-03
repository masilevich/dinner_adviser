module TypeableCategory
	extend ActiveSupport::Concern

	included do
		has_many :"#{name.sub("Category","").tableize}", foreign_key: "category_id"

		define_singleton_method "categories_for_#{name.sub("Category","").tableize}" do |collection|
      self.joins(:"#{name.sub("Category","").tableize}").where(:"#{name.sub("Category","").tableize}" => {id: collection.map(&:id)}).uniq
    end
	end

end
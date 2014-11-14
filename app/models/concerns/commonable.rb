module Commonable
	extend ActiveSupport::Concern

	included do
		scope :common, -> { where(common: true) }
	end


  	# методы класса
  	module ClassMethods
  		def exclude_by_name(items)
  			where.not(name: items.pluck(:name))
  		end

  		def common_exclude_by_name(items)
  			self.common.merge(self.exclude_by_name(items))
  		end
  	end

	  # инстанс-методы
	  module InstanceMethods

	  end
	end
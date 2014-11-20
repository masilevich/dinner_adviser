module ImportCommon
  extend ActiveSupport::Concern

  def list_common_products
    @common_products = current_user.common_exclude_self_products
  end

  def list_common_courses
    @common_courses = current_user.common_exclude_self_courses
  end

  def import_common_products
    imported_products_number = 0
    if params[:product_ids]
      @common_products = Product.find(params[:product_ids])
      @common_products.each_with_index do |product,index| 
        current_user.products.find_or_create_by(name: product.name) 
        imported_products_number = index + 1
      end
    end
    yield imported_products_number if block_given?
  end

  def import_common_courses
    imported_courses_number = 0
    if params[:course_ids]
      @common_courses = Course.find(params[:course_ids])
      @common_courses.each_with_index do |course,index| 
        imported_course = current_user.courses.find_or_create_by(name: course.name)
        course.products.each do |product|
          imported_product = current_user.products.find_or_create_by(name: product.name)
          imported_course.products << imported_product
        end  
        imported_course.save
        imported_courses_number = index + 1
      end
    end
    yield imported_courses_number if block_given?
  end

end
require 'spec_helper'
require 'shared_stuff'
require 'shared_food'

describe "CoursesPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	include_context "shared stuff"

	let(:course_name) { "Картошка" }
	
	describe "index" do
		let!(:c1) { FactoryGirl.create(:course, user: user) }
		let!(:c2) { FactoryGirl.create(:course, user: user) }
		before {visit courses_path}

		it { should have_title(full_title('Мои рецепты')) }

		it { should have_link(add_button, href: new_course_path) }
		
		it { should have_link(delete_link, href: course_path(c1)) }

		it { should have_link(c1.name, href: course_path(c1)) }

		it { should have_link("Виды блюд", href: course_categories_path) }
		it { should have_link("Импорт типовых рецептов", href: import_common_courses_path) }

		it { should have_content("Рецепты (#{user.courses.count})") }

		describe "on all courses" do
			it "should list each course" do
				within('#courses') do
					user.courses.each do |course|
						expect(page).to have_selector('td', text: course.name)
					end
				end
			end

			describe "with categories" do
				let!(:cc) { FactoryGirl.create(:course_category, user: user) }
				before do
					c1.category = cc
					visit courses_path
				end
				it "should list each category" do
					within('#courses') do
						CourseCategory.categories_for_courses(user.courses).each do |course_category|
							expect(page).to have_selector('h4', text: course_category.name)
						end
					end
				end

				it "should list empty category" do
					expect(page).to have_selector('h4', text: "Без категории")
				end
			end
		end
		

		describe "on availabled courses" do
			let!(:p1) { FactoryGirl.create(:product, available: true, user: user) }
			before do
				c1.products << p1
				visit courses_path
			end
			it "should list each course" do
				within('#courses_availabled') do
					user.courses.availabled.each do |course|
						expect(page).to have_selector('td', text: course.name)
					end
				end
			end

			specify { expect(page).to have_content("Можно приготовить (#{user.courses.availabled.to_a.count})") }

			describe "with categoriess" do
				let!(:cc) { FactoryGirl.create(:course_category, user: user) }
				before do
					c1.category = cc
					visit courses_path
				end
				it "should list each category" do
					within('#courses_availabled') do
						CourseCategory.categories_for_courses(user.courses.availabled).each do |course_category|
							expect(page).to have_selector('h4', text: course_category.name)
						end
					end
				end
			end
		end
	end

	describe "show" do
		let(:course) { FactoryGirl.create(:course_with_products,products_count: 5, user: user) }
		before do
			visit course_path(course)
		end	

		it { should have_title(full_title('Блюдо')) }

		it { should have_link('Изменить', href: edit_course_path(course)) }
		it { should have_content(course.name)}

		it "should list each product" do
			course.products.each do |product|
				expect(page).to have_selector('li', text: product.name)
			end
		end
	end

	describe "creation" do
		include_context "two products"
		before do
			visit new_course_path
		end

		it { should have_select('course_product_ids', :options => [p1.name, p2.name]) }
		it { should have_title(full_title('Новое блюдо')) }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button save_button }.not_to change(Course, :count)
			end
			describe "error messages" do
				before { click_button save_button }
				it { should have_error_message('Блюдо не добавлено') }
			end
		end

		describe "with valid information" do
			before do
				visit new_course_path
				fill_in 'course_name', with: course_name
			end
			it "should create a course" do
				expect { click_button save_button }.to change(Course, :count).by(1)
			end

			describe "and blank other fields" do
				before do
					click_button save_button
				end
				subject { Course.find_by_name(course_name) }
				its(:products) {should eq []}
				its(:ingridients) {should  eq []}
				its(:category) {should  be_nil}
			end

			describe "and product select" do
				before do
					select p1.name, :from => "course_product_ids"
					click_button save_button
				end
				it "should contain product" do
					expect(Course.find_by_name(course_name).products).to include(p1)
				end
			end

			describe "and course_category select" do
				let!(:ck1) { FactoryGirl.create(:course_category, user: user) }
				before do
					visit new_course_path
					fill_in 'course_name', with: course_name
					select ck1.name, :from => "course_category_id"
					click_button save_button
				end
				it "should contain course_category" do
					expect(Course.find_by_name(course_name).category).to eq ck1
				end
			end
		end
	end

	describe "destruction" do
		let!(:course) {FactoryGirl.create(:course,user: user)}
		before { visit courses_path }

		it "should delete a course" do
			expect { first(:link, delete_link).click }.to change(Course, :count).by(-1)
		end
	end

	describe "edit" do
		include_context "course and two products"
		let!(:ck1) { FactoryGirl.create(:course_category, user: user) }
		before {visit edit_course_path(course)}

		it { should have_select('course_product_ids', :options => [p1.name, p2.name]) }
		it { should have_select('course_category_id', :options => ['',ck1.name]) }
		it { should have_title(full_title('Изменить блюдо')) }

		describe "after save" do
			before do
				fill_in "course_name", with: course_name
				select p1.name, :from => "course_product_ids"
				select ck1.name, :from => "course_category_id"
				click_button save_button
				course.reload
			end
			it "should update a course" do
				expect(course.name).to eq course_name
			end

			it { should have_content(course_name) }

			it { should have_content("Блюдо изменено") }

			it "course should contain product" do
				expect(course.products).to include(p1)
			end

			it "course_category should contain course category" do
				expect(course.category).to eq ck1
			end
		end
	end

	describe "import common" do
		let!(:cc1) { FactoryGirl.create(:common_course) }
		let!(:cc2) { FactoryGirl.create(:common_course) }

		before do
			visit import_common_courses_path
		end	

		it { should have_title(full_title('Импорт типовых рецептов')) }
		it { should have_button('Импорт') }

		describe "list" do
			let!(:course_with_common_name) { FactoryGirl.create(:course, user: user, name: cc1.name) }
			before {visit import_common_courses_path}
			it { should have_content("Типовые рецепты (#{user.common_exclude_self_courses.count})") }

			it "each common course exclude user courses" do
				user.common_exclude_self_courses.each do |course|
					expect(page).to have_selector('td', text: course.name)
				end
			end

			it "should not show user courses" do
				user.courses.each do |course|
					expect(page).to_not have_selector('td', text: course.name)
				end
			end

			describe "course with ingridients" do
			  let!(:course_with_products) { FactoryGirl.create(:common_course_with_products) }
			  before {visit import_common_courses_path}
			  specify do 
			  	course_with_products.products.each do |product|  
			  		expect(page).to have_link(product.name, href: product_path(product)) 
			  	end
			  end
			end
		end
		
		describe "submit" do
			before do
				user.common_exclude_self_courses.each do |course|  
					check "course_chckbox_#{course.id}"
				end
				@imported_courses = user.common_exclude_self_courses.to_a
				click_button "Импорт"
			end
			it { should have_content("Блюд импортировано: #{@imported_courses.count}") }
			it "should list each imported_courses" do
				@imported_courses.each { |course|  expect(page).to have_content(course.name) }
			end
		end

		describe "with products" do
			let!(:cp1) { FactoryGirl.create(:common_product) }
			let!(:cp2) { FactoryGirl.create(:common_product) }
			let!(:p1) { FactoryGirl.create(:product, user: user, name: cp1.name) }
			before do
				cc1.products << cp1
				cc1.products << cp2
				cc1.save
				check "course_chckbox_#{cc1.id}"
				click_button "Импорт"
			end

			specify {expect(page).to have_content(cc1.name)}
			it "should copy common product to user products" do
				expect(user.products).to_not include(cp1)
				expect(user.courses.find_by(name: cc1.name).products).to include(p1)
				expect(user.products.find_by(name: cp2.name)).to_not be_nil
			end

		end

	end
end

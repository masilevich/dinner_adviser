require 'spec_helper'
require 'shared_stuff'
require 'shared_food'
require 'requests/shared_examples/import_common_shared_examples'
require 'user_helper'

describe "CoursesPages" do

	include_context "login user"
	include_context "CRUD buttons and links names"

	let(:course_name) { "Картошка" }
	let(:create_button) { "Создать Блюдо" }
	let(:save_button) { "Сохранить Блюдо" }
	
	describe "index" do
		let!(:c1) { FactoryGirl.create(:course, user: user) }
		let!(:c2) { FactoryGirl.create(:course, user: user) }
		before {visit courses_path}

		it { should have_title(full_title('Мои рецепты')) }

		it { should have_link(add_button, href: new_course_path) }
		
		it { should have_link(delete_link, href: course_path(c1)) }

		it { should have_link(c1.name, href: course_path(c1)) }

		it { should have_link("Список", href: course_categories_path) }
		it { should have_link("Импорт типовых рецептов", href: import_common_courses_path) }

		it { should have_content("Рецепты (#{user.courses.count})") }
		it { should have_content("Можно приготовить (0)") }

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
				expect { click_button create_button }.not_to change(Course, :count)
			end
			describe "error messages" do
				before { click_button create_button }
				it { should have_error_message('Блюдо не добавлено') }
			end
		end

		describe "with valid information" do
			before do
				visit new_course_path
				fill_in 'course_name', with: course_name
			end
			it "should create a course" do
				expect { click_button create_button }.to change(Course, :count).by(1)
			end

			describe "and blank other fields" do
				before do
					click_button create_button
				end
				subject { Course.find_by_name(course_name) }
				its(:products) {should eq []}
				its(:ingridients) {should  eq []}
				its(:category) {should  be_nil}
			end

			describe "and product select" do
				before do
					select p1.name, :from => "course_product_ids"
					click_button create_button
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
					click_button create_button
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

	it_should_behave_like "import common courses" do
		let(:import_path) { import_common_courses_path }
	end
end

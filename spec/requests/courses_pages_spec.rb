require 'spec_helper'
require 'shared_stuff'

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

		it { should have_link("Виды блюд", href: course_kinds_path) }

		it { should have_content("Рецепты (#{user.courses.count})") }

		describe "on all courses" do
			it "should list each course" do
				within('#courses') do
					user.courses.each do |course|
						expect(page).to have_selector('td', text: course.name)
					end
				end
			end

			describe "with kinds" do
				let!(:ck) { FactoryGirl.create(:course_kind, user: user) }
				before do
					c1.course_kind = ck
					visit courses_path
				end
				it "should list each kind" do
					within('#courses') do
						CourseKind.kinds_for_courses(user.courses).each do |course_kind|
							expect(page).to have_selector('h4', text: course_kind.name)
						end
					end
				end

				it "should list empty kind" do
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

			describe "with kinds" do
				let!(:ck) { FactoryGirl.create(:course_kind, user: user) }
				before do
					c1.course_kind = ck
					visit courses_path
				end
				it "should list each kind" do
					within('#courses_availabled') do
						CourseKind.kinds_for_courses(user.courses.availabled).each do |course_kind|
							expect(page).to have_selector('h4', text: course_kind.name)
						end
					end
				end
			end
		end
	end

	describe "show" do
		let!(:c1) { FactoryGirl.create(:course, user: user) }
		let!(:p1) { FactoryGirl.create(:product, user: user, available: true) }
		let!(:p2) { FactoryGirl.create(:product, user: user) }
		before do
			c1.products << p1
			c1.products << p2
			visit course_path(c1)
		end	

		it { should have_title(full_title('Блюдо')) }

		it { should have_link('Изменить', href: edit_course_path(c1)) }
		it { should have_content(c1.name)}

		it "should list each product" do
			c1.products.each do |product|
				expect(page).to have_selector('li', text: product.name)
			end
		end
	end

	describe "creation" do
		let!(:p1) { FactoryGirl.create(:product, user: user, available: true) }
		let!(:p2) { FactoryGirl.create(:product, user: user) }
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

			describe "and product select" do
				before do
					select p1.name, :from => "course_product_ids"
					click_button save_button
				end
				it "should contain product" do
					expect(Course.find_by_name(course_name).products).to include(p1)
				end
			end

			describe "and product select blank" do
				before do
					fill_in 'course_name', with: course_name
					click_button save_button
					@course = Course.find_by_name(course_name)
				end
				it "should not contain products and ingridients" do
					expect(@course.products).to eq []
					expect(@course.ingridients).to eq []
				end
			end

			describe "and course_kind select" do
				let!(:ck1) { FactoryGirl.create(:course_kind, user: user) }
				before do
					visit new_course_path
					fill_in 'course_name', with: course_name
					select ck1.name, :from => "course_course_kind_id"
					click_button save_button
				end
				it "should contain course_kind" do
					expect(Course.find_by_name(course_name).course_kind).to eq ck1
				end
			end

			describe "and course_kind select blank" do
				before do
					fill_in 'course_name', with: course_name
					click_button save_button
					@course = Course.find_by_name(course_name)
				end
				it "should not contain course_kinds and ingridients" do
					expect(@course.course_kind).to be_nil
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
		let!(:course) {FactoryGirl.create(:course,user: user)}
		let!(:p1) { FactoryGirl.create(:product, user: user, available: true) }
		let!(:p2) { FactoryGirl.create(:product, user: user) }
		let!(:ck1) { FactoryGirl.create(:course_kind, user: user) }
		before {visit edit_course_path(course)}

		it { should have_select('course_product_ids', :options => [p1.name, p2.name]) }
		it { should have_select('course_course_kind_id', :options => ['',ck1.name]) }
		it { should have_title(full_title('Изменить блюдо')) }

		describe "after save" do
			before do
				fill_in "course_name", with: course_name
				select p1.name, :from => "course_product_ids"
				select ck1.name, :from => "course_course_kind_id"
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

			it "course_kind should contain course kind" do
				expect(course.course_kind).to eq ck1
			end
		end
	end
end

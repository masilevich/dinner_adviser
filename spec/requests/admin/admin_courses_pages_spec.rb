require 'spec_helper'
require 'shared_stuff'
require 'shared_food'

describe "Admin::CoursesPages" do
	include Warden::Test::Helpers
	Warden.test_mode!
	include_context "login user"
	include_context "CRUD buttons and links names"
	let(:create_button) { "Создать Блюдо" }
	let(:save_button) { "Сохранить Блюдо" }


	let(:admin) {FactoryGirl.create(:admin)}
	before do
		login_as(admin, :scope => :user)
	end

	subject { page }

	let(:course_name) { "Жареная курица" }

	describe "index" do
		let!(:course) { FactoryGirl.create(:common_course_with_products,products_count: 5) }
		let!(:cc1) { FactoryGirl.create(:common_course) }
		let!(:cc2) { FactoryGirl.create(:common_course) }
		before {visit admin_courses_path}

		it { should have_title(full_title('Типовые рецепты')) }
		it { should have_link('Типовые рецепты', href: admin_courses_path) }

		it { should have_link(add_button, href: new_admin_course_path) }
		it { should have_link(delete_link, href: admin_course_path(cc1)) }
		it { should have_link(cc1.name, href: admin_course_path(cc1)) }
		it { should have_link(cc2.name, href: admin_course_path(cc2)) }

		describe "on all courses" do
			it { should have_content("Все (#{Course.common.count})") }

			describe "should list each course" do
				specify do
					Course.common.each do |course|
						expect(page).to have_selector('td', text: course.name)
					end
				end

				describe "with products" do
					specify do
						Course.common.each do |course|
							course.products.each do |product|
								expect(page).to have_link(product.name, href: admin_product_path(product))
							end
						end
					end
				end
			end

		end
	end

	describe "creation" do
		include_context "two common products"
		before do 
			visit new_admin_course_path
		end

		it { should have_title(full_title('Новый типовой рецепт')) }
		it { should have_link('Типовые рецепты', href: admin_courses_path) }
		it { should have_select('course_product_ids', :options => [cp1.name, cp2.name]) }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button create_button }.not_to change(Course, :count)
			end

			describe "render" do
				before { click_button create_button }

				describe "error messages" do
					before { click_button create_button }
					it { should have_error_message('Блюдо не добавлено') }
				end

				describe "right action" do
					it { should have_title(full_title('Новый типовой рецепт')) }
				end
			end
		end

		describe "with valid information" do
			before {fill_in 'course_name', with: course_name }

			describe "after save" do
				before do
					click_button create_button
					@course = Course.find_by_name(course_name)
				end

				specify {expect(@course.common).to be_true}
				it { should have_title(full_title('Типовые рецепты')) }

			end

			it "should create a course" do
				expect { click_button create_button }.to change(Course.common, :count).by(1)
			end

		end
	end

	describe "edit" do
		include_context "common course and two products"
		before {visit edit_admin_course_path(course) }

		it { should have_title(full_title('Изменить типовой рецепт')) }
		it { should have_select('course_product_ids', :options => [cp1.name, cp2.name]) }

		describe "after save" do
			before do
				fill_in "course_name", with: course_name
				select cp1.name, :from => "course_product_ids"
				click_button save_button
				course.reload
			end
			it "should update a course" do
				expect(course.name).to eq course_name
			end

			it { should have_content(course_name) }

			it { should have_content("Блюдо изменено") }
			it { should have_title(full_title('Типовые рецепты')) }

			it "course should contain product" do
				expect(course.products).to include(cp1)
			end
		end

		describe "with invalid information" do

			before do
				fill_in "course_name", with: ""
				click_button save_button
			end

			describe "error messages" do
				it { should have_error_message('Блюдо не изменено') }
			end

			describe " render right action" do
				it { should have_title(full_title('Изменить типовой рецепт')) }
			end
		end
	end

	describe "destruction" do
		let!(:course) {FactoryGirl.create(:common_course)}
		describe "in courses controller pages" do

			before { visit admin_courses_path }
			it "delete a course" do
				expect { click_link delete_link }.to change(Course, :count).by(-1)
			end

			describe "have link to destroy" do
				specify {expect(page).to have_link(delete_link, admin_course_path(course))}
			end
		end
	end

	describe "show" do
		let(:course) { FactoryGirl.create(:common_course_with_products,products_count: 5) }
		before do
			visit admin_course_path(course)
		end	

		it { should have_title(full_title('Типовой рецепт')) }

		it { should have_link('Изменить', href: edit_admin_course_path(course)) }
		it { should have_content(course.name)}

		it "should list each product" do
			course.products.each do |product|
				expect(page).to have_selector('li', text: product.name)
			end
		end
	end
end

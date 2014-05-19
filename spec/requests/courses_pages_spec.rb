require 'spec_helper'

describe "CoursesPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	describe "index" do
		let!(:c1) { FactoryGirl.create(:course, user: user, name: 'Пюре') }
		let!(:c2) { FactoryGirl.create(:course, user: user, name: 'Жареная курица') }
		before {visit courses_path}

		it { should have_title(full_title('Блюда')) }

		it { should have_link('Добавить', href: new_course_path) }
		it { should have_link('удалить', href: course_path(c1)) }
		it { should have_link('изменить', href: edit_course_path(c1)) }

		it { should have_content("Блюда (#{user.courses.count})") }

		it "should list each course" do
			user.courses.each do |course|
				expect(page).to have_selector('li', text: course.name)
			end
		end
	end

	describe "creation" do
		let!(:p1) { FactoryGirl.create(:product, user: user, name: 'Картошка', available: true) }
		before do
			visit new_course_path
		end

		it { should have_select('course_product_ids', :options => [p1.name]) }
		it { should have_title(full_title('Новое блюдо')) }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button "Добавить" }.not_to change(Course, :count)
			end
			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_content('Блюдо не добавлено') }
			end
		end

		describe "with valid information" do
			before do
				visit new_course_path
				fill_in 'course_name', with: "Жареная курица"
				select p1.name, :from => "course_product_ids"
			end
			it "should create a course" do
				expect { click_button "Добавить" }.to change(Course, :count).by(1)
			end

			it "course should contain product" do
				click_button "Добавить"
				expect(Course.find_by_name("Жареная курица").products).to include(p1)
			end
		end
	end

	describe "destruction" do
		let!(:course) {FactoryGirl.create(:course,user: user)}
		before { visit courses_path }

		it "should delete a course" do
			expect { click_link "удалить" }.to change(Course, :count).by(-1)
		end

	end

	describe "edit" do
		let!(:course) {FactoryGirl.create(:course,user: user, name: "Пюре")}
		let!(:p1) { FactoryGirl.create(:product, user: user, name: 'Картошка', available: true) }
		before do
		  visit edit_course_path(course)
		  fill_in "course_name", with: "Картошка"
		  select p1.name, :from => "course_product_ids"
		  click_button "Сохранить"
		  course.reload
		end 
		it "should update a course" do
			expect(course.name).to eq "Картошка"
		end

		it { should have_content("Картошка") }

		it { should have_content("Блюдо изменено") }

		it "course should contain product" do
			expect(course.products).to include(p1)
		end
	end
end

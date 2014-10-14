require 'spec_helper'
require 'shared_stuff'


describe "MenusPages" do
	include Warden::Test::Helpers
	Warden.test_mode!
	include_context "shared stuff"
	include AsyncHelper

	shared_context "two courses" do
		let!(:c1) { FactoryGirl.create(:course, user: user) }
		let!(:c2) { FactoryGirl.create(:course, user: user) }
	end

	shared_context "menu and two courses" do
		include_context "two courses"
		let!(:menu) {FactoryGirl.create(:menu, user: user)}
	end

	describe "index" do
		let!(:m1) { FactoryGirl.create(:menu, user: user) }
		let!(:m2) { FactoryGirl.create(:menu, user: user) }
		before {visit menus_path}

		it { should have_title(full_title('Меню')) }

		it { should have_link(add_button, href: new_menu_path) }
		
		it { should have_link(delete_link, href: menu_path(m1)) }

		it { should have_link(m1.date, href: menu_path(m1)) }

		it { should have_link("Виды меню", href: menu_categories_path) }

		it { should have_content("Меню (#{user.menus.count})") }

		describe "on all menus" do
			it "should list each menu" do
				within('#menus') do
					user.menus.each do |menu|
						expect(page).to have_selector('td', text: menu.date)
						expect(page).to have_selector('td', text: menu.category)
					end
				end
			end
		end	
	end

	describe "destruction" do
		let!(:menu) {FactoryGirl.create(:menu,user: user)}
		before { visit menus_path }

		it "should delete a menu" do
			expect { first(:link, delete_link).click }.to change(Menu, :count).by(-1)
		end
	end

	describe "creation" do
		include_context "two courses"
		before do
			visit new_menu_path
		end

		it { should have_title(full_title('Новое меню')) }

		describe "with valid information" do
			before do
				@menu_date = DateTime.now.to_date - 5.day
				visit new_menu_path
				fill_in 'menu_date', with: @menu_date
			end
			it "should create a menu" do
				expect { click_button save_button }.to change(Menu, :count).by(1)
			end

			describe "and menu_category select" do
				let!(:mk1) { FactoryGirl.create(:menu_category, user: user) }
				before do
					visit new_menu_path
					fill_in 'menu_date', with: @menu_date
					select mk1.name, :from => "menu_category_id"
					click_button save_button
				end
				it "should contain menu_category" do
					expect(Menu.find_by_date(@menu_date).category).to eq mk1
				end
			end

			describe "and menu_category select blank" do
				before do
					click_button save_button
				end
				it "should not contain menu_categories" do
					expect(Menu.find_by_date(@menu_date).category).to be_nil
				end
			end

			describe "and courses", js: true  do

				describe "take to menu" do
					before { within('#courses') {first(:checkbox, "course_chckbox_#{c1.id}").click}}
					it "should move course to in menu table" do
						within('#courses_in_menu') do
							expect(page).to have_selector('td', text: c1.name)
						end

					end

					describe "should be in menu courses" do		
						before do
							page.find('#save_button').trigger('click')
						end

						it "after save" do
							expect(page).to have_content("Меню добавлено")
						end
					end


					describe "and then remove from menu" do
						before do
							within('#courses_in_menu') {first(:checkbox, "course_chckbox_#{c1.id}").click	}
							sleep(0.1)
						end
						it "should remove course from inmenu table" do
							expect(page).to_not have_selector("#courses_in_menu")
						end
					end
				end
			end			
		end
	end

	describe "show" do
		let!(:menu_category) { FactoryGirl.create(:menu_category, user: user) }
		let(:menu) { FactoryGirl.create(:menu_with_courses, courses_count: 5, user: user) }
		before do
			menu.category = menu_category
			menu_category.save
			menu.save
			visit menu_path(menu)
		end	

		it { should have_title(full_title('Меню')) }

		it { should have_link(change_link, href: edit_menu_path(menu)) }
		it { should have_content("Меню#{menu.category ? (" " + menu.category.name) : ""} на #{menu.date}")}

		it "should list each course" do
			expect(page).to have_content('Блюда')
			menu.courses.each do |course|
				expect(page).to have_selector('li', text: course.name)
			end
		end
	end

	describe "edit" do

		let!(:new_menu_category) { FactoryGirl.create(:menu_category, user: user) }
		let!(:old_menu_category) { FactoryGirl.create(:menu_category, user: user) }
		let!(:old_date) { DateTime.now.to_date }
		let!(:menu) {FactoryGirl.create(:menu, user: user, category: old_menu_category, date: old_date)}
		#include_context "menu and two courses"
		before do
			visit edit_menu_path(menu)
		end

		it { should have_select('menu_category_id', :options => ['',new_menu_category.name, old_menu_category.name]) }
		it { should have_title(full_title('Изменить меню')) }
		it { should have_content(new_menu_category.name) }
		it { should have_field("menu_date", with: old_date.strftime("%Y-%m-%d")) }



		describe "after save" do
			before do
				@new_menu_date = DateTime.now.to_date - 5.day
				fill_in 'menu_date', with: @new_menu_date
				select new_menu_category.name, :from => "menu_category_id"
				click_button save_button
				menu.reload
			end
			it "should update a menu" do
				expect(menu.date).to eq @new_menu_date
			end

			it { should have_content(@new_menu_date) }

			it { should have_content("Меню изменено") }

			it "menu_category should contain menu category" do
				expect(menu.category).to eq new_menu_category
			end
		end
	end
end

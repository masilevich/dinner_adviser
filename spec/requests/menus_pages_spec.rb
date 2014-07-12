require 'spec_helper'
require 'shared_stuff'

describe "MenusPages" do
	include Warden::Test::Helpers
	Warden.test_mode!
	include_context "shared stuff"

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

		it { should have_link("Виды меню", href: menu_kinds_path) }

		it { should have_content("Меню (#{user.menus.count})") }

		describe "on all menus" do
			it "should list each menu" do
				within('#menus') do
					user.menus.each do |menu|
						expect(page).to have_selector('td', text: menu.date)
						expect(page).to have_selector('td', text: menu.menu_kind)
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

			describe "and menu_kind select" do
				let!(:mk1) { FactoryGirl.create(:menu_kind, user: user) }
				before do
					visit new_menu_path
					fill_in 'menu_date', with: @menu_date
					select mk1.name, :from => "menu_menu_kind_id"
					click_button save_button
				end
				it "should contain menu_kind" do
					expect(Menu.find_by_date(@menu_date).menu_kind).to eq mk1
				end
			end

			describe "and menu_kind select blank" do
				before do
					click_button save_button
				end
				it "should not contain menu_kinds" do
					expect(Menu.find_by_date(@menu_date).menu_kind).to be_nil
				end
			end
		end
	end

	describe "show" do
		let!(:menu_kind) { FactoryGirl.create(:menu_kind, user: user) }
		let(:menu) { FactoryGirl.create(:menu_with_courses, courses_count: 5, user: user) }
		before do
			menu.menu_kind = menu_kind
			menu_kind.save
			menu.save
			visit menu_path(menu)
		end	

		it { should have_title(full_title('Меню')) }

		it { should have_link(change_link, href: edit_menu_path(menu)) }
		it { should have_content("Меню#{menu.menu_kind ? (" " + menu.menu_kind.name) : ""} на #{menu.date}")}

		it "should list each course" do
			expect(page).to have_content('Блюда')
			menu.courses.each do |course|
				expect(page).to have_selector('li', text: course.name)
			end
		end
	end

	describe "edit" do
		let!(:menu_kind) { FactoryGirl.create(:menu_kind, user: user) }
		include_context "menu and two courses"
		before {visit edit_menu_path(menu)}

		it { should have_select('menu_menu_kind_id', :options => ['',menu_kind.name]) }
		it { should have_title(full_title('Изменить меню')) }

		describe "after save" do
			before do
				@menu_date = DateTime.now.to_date - 5.day
				fill_in 'menu_date', with: @menu_date
				select menu_kind.name, :from => "menu_menu_kind_id"
				click_button save_button
				menu.reload
			end
			it "should update a menu" do
				expect(menu.date).to eq @menu_date
			end

			it { should have_content(@menu_date) }

			it { should have_content("Меню изменено") }

			it "menu_kind should contain menu kind" do
				expect(menu.menu_kind).to eq menu_kind
			end
		end
	end
end

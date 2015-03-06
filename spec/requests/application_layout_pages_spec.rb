require 'spec_helper'
require 'user_helper'

describe "ApplicationLayoutPages" do

	subject { page }

	describe "for signed-in" do
		describe "user" do
			include_context "login user"
			before do 
				visit root_path
			end

			describe "sidebar" do
				let(:advice_menu_label) {"Случайный рецепт"}
				let(:products_menu_label) {"Продукты"}
				let(:courses_menu_label) {"Мои рецепты"}
				let(:menus_menu_label) {"Меню"}
				let(:shopping_lists_menu_label) {"Списки покупок"}

				it "should have food links" do
					expect(page).to have_link(advice_menu_label , href: advice_path )
					expect(page).to have_link(products_menu_label, href: products_path)
					expect(page).to have_link(courses_menu_label, href: courses_path)
					expect(page).to have_link(menus_menu_label, href: menus_path)
					expect(page).to have_link(shopping_lists_menu_label, href: shopping_lists_path)
				end

				it "should switch active nav link" do
					click_link advice_menu_label
					expect(page).to have_selector('li.active', text: advice_menu_label)
					click_link products_menu_label
					expect(page).to have_selector('li.active', text: products_menu_label)
					click_link courses_menu_label
					expect(page).to have_selector('li.active', text: courses_menu_label)
					click_link menus_menu_label
					expect(page).to have_selector('li.active', text: menus_menu_label)
					click_link shopping_lists_menu_label
					expect(page).to have_selector('li.active', text: shopping_lists_menu_label)
				end

				describe "switch" do
					describe "through visit another resource" do
						let(:menu) {FactoryGirl.create(:menu, user: user)}
						before {visit menu_path(menu)}
						it "should change current tab" do
							expect(page).to have_selector('li.active', text: menus_menu_label)
						end
					end
				end
			end

			describe "header" do
				it { should_not have_link("Регистрация", href: new_user_registration_path) }
				it { should_not have_link("Администрирование", href: admin_root_path) }
			end
		end

		describe "admin" do
			include Warden::Test::Helpers
			Warden.test_mode!

			let(:admin) {FactoryGirl.create(:admin)}

			before do
				login_as(admin, :scope => :user)
				visit root_path
			end

			after do
				Warden.test_reset!
			end

			it { should have_link("Администрирование", href: admin_root_path) }

			before {click_link "Администрирование"}

			describe "sidebar" do
				let(:products_menu_label) {"Базовые продукты"}
				let(:courses_menu_label) {"Типовые рецепты"}

				it "should have common food links" do
					expect(page).to have_link(products_menu_label, href: admin_products_path)
					expect(page).to have_link(courses_menu_label, href: admin_courses_path)
				end

				it "should switch active nav link" do
					click_link products_menu_label
					expect(page).to have_selector('li.active', text: products_menu_label)
					click_link courses_menu_label
					expect(page).to have_selector('li.active', text: courses_menu_label)
				end

			end
		end
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "О нас"
		expect(page).to have_title(full_title('О нас'))
		click_link "Контакты"
		expect(page).to have_title(full_title('Контакты'))
		click_link "Главная"
		page.first(:link, "Зарегистрироваться").click
		expect(page).to have_title( full_title('Зарегистрироваться'))
		click_link "Обеденный советник"
		expect(page).to have_title( full_title(''))
	end
end

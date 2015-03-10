require 'spec_helper'
require 'user_helper'

shared_examples "default on page menu" do |controller_path|
	let(:index_label) {"Список"}
	let(:new_label) {"Создать новый"}
	it "should have links" do
		expect(page).to have_link(index_label, href: controller_path)
		expect(page).to have_link(new_label, href: "#{controller_path}/new")
	end

	it "should switch active link" do
		expect(page).to have_selector('li.active', text: index_label)
		click_link new_label
		expect(page).to have_selector('li.active', text: new_label)
	end
end

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

			describe "on page menu" do

				context "advice" do
					before {visit advice_path}
					specify { expect(page).to_not have_selector('div#on_page_menu') }
				end

				context "products pages" do
					before {visit products_path}

					it_should_behave_like "default on page menu", "/products"
					it "should have links" do
						expect(page).to have_link("Импорт базовых продуктов", 
							href: import_common_products_path)
						expect(page).to have_link("Список", href: product_categories_path)
						expect(page).to have_link("Добавить новый", href: new_product_category_path)
					end

					it "should switch active link" do
						click_link "Импорт базовых продуктов"
						expect(page).to have_selector('li.active', text: "Импорт базовых продуктов")
					end
				end

				context "courses pages" do
					before {visit courses_path}
					it_should_behave_like "default on page menu", "/courses"

					it "should have links" do
						expect(page).to have_link("Импорт типовых рецептов", 
							href: import_common_courses_path)
						expect(page).to have_link("Список", href: course_categories_path)
						expect(page).to have_link("Добавить новый", href: new_course_category_path)
					end

					it "should switch active link" do
						click_link "Импорт типовых рецептов"
						expect(page).to have_selector('li.active', text: "Импорт типовых рецептов")
					end
				end

				context "menus pages" do
					before {visit menus_path}
					it_should_behave_like "default on page menu", "/menus"
					it "should have links" do
						expect(page).to have_link("Список", href: menu_categories_path)
						expect(page).to have_link("Добавить новый", href: new_menu_category_path)
					end
				end

				context "shopping lists pages" do
					before {visit shopping_lists_path}
					it_should_behave_like "default on page menu", "/shopping_lists"
				end
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

			describe "on page menu" do
				context "products pages" do
					before {visit admin_products_path}
					it_should_behave_like "default on page menu", "/admin/products"
				end

				context "courses pages" do
					before {visit admin_courses_path}
					it_should_behave_like "default on page menu", "/admin/courses"
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

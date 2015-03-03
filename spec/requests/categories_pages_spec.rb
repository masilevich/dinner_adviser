require 'spec_helper'

describe "categories_pages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	CATEGORYTYPES = ["ProductCategory","MenuCategory","CourseCategory"]
	RUTYPEPLURALIZE = {"ProductCategory" => "продуктов", "CourseCategory" => "блюд", "MenuCategory" => "меню"}
	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	CATEGORYTYPES.each do |type|
	let(:create_button) { "Добавить" }
	let(:save_button) { "Сохранить Категория" }

		describe "creation" do
			before {visit polymorphic_path(type.tableize)}
			describe "with invalid information" do

				it "should not create a #{type}" do
					expect { click_button create_button }.not_to change(type.constantize, :count)
				end

				describe "error messages" do
					before { click_button create_button }
					it { should have_error_message("Вид #{RUTYPEPLURALIZE[type]} не добавлен") }
				end
			end

			describe "with valid information" do
				before {fill_in "#{type.underscore}_name", with: type }
				it "should create a #{type.constantize}" do
					expect { click_button create_button }.to change(type.constantize, :count).by(1)
				end
			end

		end


		describe "destruction" do
			let!(:"#{type.underscore}") {FactoryGirl.create(:"#{type.underscore}", user: user)}
			describe "in #{type}s controller pages" do

				before { visit polymorphic_path(type.tableize) }
				it "should delete a #{type}" do
					expect { click_link "удалить" }.to change(type.constantize, :count).by(-1)
				end

				describe "should have link to destroy" do
					specify {expect(page).to have_link("удалить", polymorphic_path(type.underscore.tableize))}
				end
			end

		end


		describe "index" do
			let!(:c1) { FactoryGirl.create(:"#{type.underscore}", user: user) }
			let!(:c2) { FactoryGirl.create(:"#{type.underscore}", user: user) }
			before {visit polymorphic_path(type.tableize)}

			it { should have_title(full_title("Виды #{RUTYPEPLURALIZE[type]}")) }

			it { should have_button('Добавить') }
			it { should have_link('удалить', href: polymorphic_path(c1)) }
			it { should have_link(c1.name, href: edit_polymorphic_path(c1)) }
			it { should have_link(c2.name, href: edit_polymorphic_path(c2)) }

			describe "on all #{type.tableize}" do
				it { should have_content("Все (#{user.categories.send(type.tableize).count})") }

				it "should list each #{type.underscore}" do
					user.categories.send(type.tableize).each do |category|
						expect(page).to have_selector('td', text: category.name)
					end
				end
			end

		end


		describe "edit" do
			let!(:category) {FactoryGirl.create(:"#{type.underscore}", user: user)}
			let(:new_category_name) { "Новая категория #{RUTYPEPLURALIZE[type]}" }
			before do
				visit edit_polymorphic_path(category)
				fill_in "#{type.underscore}_name", with: new_category_name
				click_button save_button
			end 
			it "should update a #{type.tableize}" do
				expect(category.reload.name).to eq new_category_name
			end

			it { should have_content(new_category_name) }

			it { should have_content("Вид #{RUTYPEPLURALIZE[type]} изменен") }

		end
	end

end
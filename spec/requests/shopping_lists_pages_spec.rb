require 'spec_helper'
require 'shared_stuff'
require 'shared_food'
require 'user_helper'

describe "ShoppingListSPages" do

	include_context "login user"
	include_context "CRUD buttons and links names"
	let(:create_button) { "Создать Список покупок" }
	let(:save_button) { "Сохранить Список покупок" }

	let(:shopping_list_name) { "Список покупок на выходные" }

	describe "creation" do
		before {visit new_shopping_list_path}

		it { should have_title(full_title('Новый список покупок')) }

		describe "with invalid information" do

			it "should not create a shopping_list" do
				expect { click_button create_button }.not_to change(ShoppingList, :count)
			end

			describe "error messages" do
				before { click_button create_button }
				it { should have_error_message('Список покупок не добавлен') }

				describe "after visiting another page" do
					before { click_link "Главная" }
					it { should_not have_selector('div.alert.alert-warning') }
				end
			end
		end

		describe "with valid information" do
			before {fill_in 'shopping_list_name', with: shopping_list_name }

			describe "after save" do
				before do
					click_button create_button
					@shopping_list = ShoppingList.find_by_name(shopping_list_name)
				end

				specify {expect(@shopping_list.name).to eq(shopping_list_name)}
			end

			it "should create a shopping_list" do
				expect { click_button create_button }.to change(ShoppingList, :count).by(1)
			end

		end
	end

	describe "index" do
		let!(:sl1) { FactoryGirl.create(:shopping_list, user: user) }
		let!(:sl2) { FactoryGirl.create(:shopping_list, user: user) }
		before {visit shopping_lists_path}

		it { should have_title(full_title('Списки покупок')) }

		it { should have_link(add_button, href: new_shopping_list_path) }
		
		it { should have_link(delete_link, href: shopping_list_path(sl1)) }

		it { should have_link(sl1.name, href: shopping_list_path(sl1)) }

		it { should have_content("Списки покупок (#{user.shopping_lists.count})") }

		describe "on all shopping_lists" do
			it "should list each shopping_list" do
				within('#shopping_lists') do
					user.shopping_lists.each do |shopping_list|
						expect(page).to have_selector('td', text: shopping_list.name)
					end
				end
			end
		end	
	end

	describe "destruction" do
		let!(:shopping_list) {FactoryGirl.create(:shopping_list,user: user)}
		before { visit shopping_lists_path }

		it "should delete a shopping_list" do
			expect { first(:link, delete_link).click }.to change(ShoppingList, :count).by(-1)
		end
	end

	describe "edit" do
		include_context "shopping list and two products"
		before do
			shopping_list.products << p1
			shopping_list.save
			visit edit_shopping_list_path(shopping_list) 
		end

		it { should have_title(full_title('Изменить список покупок')) }
		it { should have_content("В списке покупок (#{shopping_list.products.to_a.count})") }

		describe "before save" do
		  it "show products in shopping list" do
		  	within('#products_in_shopping_list') do
					expect(page).to have_content(p1.name)
					expect(page).to_not have_content(p2.name)
				end
		  end
		end

		describe "after save" do
			before do
				fill_in "shopping_list_name", with: shopping_list_name
				click_button save_button
				shopping_list.reload
			end

			it "should update a shopping_list" do
				expect(shopping_list.name).to eq shopping_list_name
			end

			it { should have_content(shopping_list_name) }

			it { should have_content("Список покупок изменен") }

		end
	end

	describe "show" do
		include_context "shopping list and two products"
		before do
			shopping_list.products << p1
			shopping_list.save
			visit shopping_list_path(shopping_list)
		end	

		it { should have_title(full_title('Список покупок')) }

		it { should have_link(change_link, href: edit_shopping_list_path(shopping_list)) }
		it { should have_content(shopping_list.name)}

		it "should list each product" do
			expect(page).to have_content('Продукты')
			shopping_list.products.each do |product|
				expect(page).to have_selector('li', text: product.name)
			end
		end
	end
end

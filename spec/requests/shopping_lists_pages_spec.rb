require 'spec_helper'
require 'shared_stuff'

describe "ShoppingListSPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	include_context "shared stuff"

	let(:shopping_list_name) { "Список покупок на выходные" }

	describe "creation" do
		before {visit new_shopping_list_path}

		it { should have_title(full_title('Новый список покупок')) }

		describe "with invalid information" do

			it "should not create a shopping_list" do
				expect { click_button save_button }.not_to change(ShoppingList, :count)
			end

			describe "error messages" do
				before { click_button save_button }
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
					click_button save_button
					@shopping_list = ShoppingList.find_by_name(shopping_list_name)
				end

				specify {expect(@shopping_list.name).to eq(shopping_list_name)}
			end

			it "should create a shopping_list" do
				expect { click_button save_button }.to change(ShoppingList, :count).by(1)
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
		let!(:shopping_list) {FactoryGirl.create(:shopping_list,user: user)}
		before {visit edit_shopping_list_path(shopping_list) }

		it { should have_title(full_title('Изменить список покупок')) }

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
		let!(:shopping_list) {FactoryGirl.create(:shopping_list,user: user, name: shopping_list_name)}
		before do
			visit shopping_list_path(shopping_list)
		end	

		it { should have_title(full_title('Список покупок')) }

		it { should have_link(change_link, href: edit_shopping_list_path(shopping_list)) }
		it { should have_content(shopping_list_name)}

	end
end

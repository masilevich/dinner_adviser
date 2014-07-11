require 'spec_helper'

describe "menu_kindsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

begin
	describe "creation" do
		before {visit menu_kinds_path}
		describe "with invalid information" do

			it "should not create a MenuKind" do
				expect { click_button "Добавить" }.not_to change(MenuKind, :count)
			end

			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_error_message('Вид меню не добавлен') }
			end
		end

		describe "with valid information" do
			before {fill_in 'menu_kind_name', with: "Вечернее" }
			it "should create a MenuKind" do
				expect { click_button "Добавить" }.to change(MenuKind, :count).by(1)
			end
		end

	end

	describe "destruction" do
		let!(:menu_kind) {FactoryGirl.create(:menu_kind, user: user)}
		describe "in MenuKinds controller pages" do

			before { visit menu_kinds_path }
			it "should delete a MenuKind" do
				expect { click_link "удалить" }.to change(MenuKind, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link("удалить", menu_kind_path(menu_kind))}
			end
		end

		describe "link should be only on MenuKind contoller pages" do
			let!(:p1) { FactoryGirl.create(:menu, user: user, date: Time.now) }
			before do
				p1.menu_kind = menu_kind
				visit menus_path
			end	
			specify {expect(page).to_not have_link("удалить", href: menu_kind_path(menu_kind))}
		end
	end

	describe "edit" do
		let!(:menu_kind) {FactoryGirl.create(:menu_kind,user: user, name: "Обеденное")}
		before do
			visit edit_menu_kind_path(menu_kind)
			fill_in "menu_kind_name", with: "Вечернее"
			click_button "Сохранить"
		end 
		it "should update a menu_kind" do
			expect(menu_kind.reload.name).to eq "Вечернее"
		end

		it { should have_content("Вечернее") }

		it { should have_content("Вид меню изменен") }

	end
end
	describe "index" do
		let!(:mk1) { FactoryGirl.create(:menu_kind, user: user, name: 'Обеденное') }
		let!(:mk2) { FactoryGirl.create(:menu_kind, user: user, name: 'Вечернее') }
		before {visit menu_kinds_path}

		it { should have_title(full_title('Виды меню')) }

		it { should have_button('Добавить') }
		it { should have_link('удалить', href: menu_kind_path(mk1)) }
		it { should have_link(mk1.name, href: edit_menu_kind_path(mk1)) }
		it { should have_link(mk2.name, href: edit_menu_kind_path(mk2)) }

		describe "on all menu_kinds" do
			it { should have_content("Все (#{user.menu_kinds.count})") }

			it "should list each menu_kind" do
				user.menu_kinds.each do |menu_kind|
					expect(page).to have_selector('td', text: menu_kind.name)
				end
			end
		end

	end

end



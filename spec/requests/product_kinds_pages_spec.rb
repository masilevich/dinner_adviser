require 'spec_helper'

describe "product_kindsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	describe "creation" do
		before {visit product_kinds_path}
		describe "with invalid information" do

			it "should not create a ProductKind" do
				expect { click_button "Добавить" }.not_to change(ProductKind, :count)
			end

			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_error_message('Вид продуктов не добавлен') }
			end
		end

		describe "with valid information" do
			before {fill_in 'product_kind_name', with: "Овощи" }
			it "should create a ProductKind" do
				expect { click_button "Добавить" }.to change(ProductKind, :count).by(1)
			end
		end

	end

	describe "destruction" do
		let!(:product_kind) {FactoryGirl.create(:product_kind, user: user)}
		describe "in ProductKinds controller pages" do

			before { visit product_kinds_path }
			it "should delete a ProductKind" do
				expect { click_link "удалить" }.to change(ProductKind, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link("удалить", product_kind_path(product_kind))}
			end
		end

		describe "link should be only on ProductKind contoller pages" do
			let!(:p1) { FactoryGirl.create(:product, user: user, name: 'Огурцы') }
			before do
				p1.product_kind = product_kind
				visit products_path
			end	
			specify {expect(page).to_not have_link("удалить", href: product_kind_path(product_kind))}
		end
	end

	describe "edit" do
		let!(:product_kind) {FactoryGirl.create(:product_kind,user: user, name: "Овощи")}
		before do
			visit edit_product_kind_path(product_kind)
			fill_in "product_kind_name", with: "Фрукты"
			click_button "Сохранить"
		end 
		it "should update a product_kind" do
			expect(product_kind.reload.name).to eq "Фрукты"
		end

		it { should have_content("Фрукты") }

		it { should have_content("Вид продуктов изменен") }

	end

	describe "index" do
		let!(:pk1) { FactoryGirl.create(:product_kind, user: user, name: 'Овощи') }
		let!(:pk2) { FactoryGirl.create(:product_kind, user: user, name: 'Фрукты') }
		before {visit product_kinds_path}

		it { should have_title(full_title('Виды продуктов')) }

		it { should have_button('Добавить') }
		it { should have_link('удалить', href: product_kind_path(pk1)) }
		it { should have_link(pk1.name, href: edit_product_kind_path(pk1)) }
		it { should have_link(pk2.name, href: edit_product_kind_path(pk2)) }

		describe "on all product_kinds" do
			it { should have_content("Все (#{user.product_kinds.count})") }

			it "should list each product_kind" do
				user.product_kinds.each do |product_kind|
					expect(page).to have_selector('td', text: product_kind.name)
				end
			end
		end

	end

end


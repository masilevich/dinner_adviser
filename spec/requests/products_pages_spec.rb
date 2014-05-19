require 'spec_helper'

describe "ProductsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	describe "creation" do
		before {visit products_path}
		describe "with invalid information" do

			it "should not create a product" do
				expect { click_button "Добавить" }.not_to change(Product, :count)
			end

			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_content('Продукт не добавлен') }
			end
		end

		describe "with valid information" do
			before {fill_in 'product_name', with: "Капуста" }
			it "should create a product" do
				expect { click_button "Добавить" }.to change(Product, :count).by(1)
			end
		end

	end

	describe "destruction" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		before { visit products_path }
		it "should delete a product" do
			expect { click_link "удалить" }.to change(Product, :count).by(-1)
		end
	end

	describe "edit" do
		let!(:product) {FactoryGirl.create(:product,user: user, name: "Пюре")}
		before do
			visit edit_product_path(product)
			fill_in "product_name", with: "Картошка"
			click_button "Сохранить"
		end 
		it "should update a product" do
			expect(product.reload.name).to eq "Картошка"
		end

		it { should have_content("Картошка") }

		it { should have_content("Продукт изменен") }

	end

	describe "manipulation" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		before { visit products_path }

		describe "mark available" do
			before {click_link "в наличии"}
			it "should make product available" do
				expect(product.reload).to be_available
			end
		end

		describe "mark unavailable" do
			before do
				product.update_attribute(:available, true)
				visit products_path
				first(:link, "отсутствует").click
			end
			it "should make product unavailable" do
				expect(product.reload).to_not be_available
			end
		end
	end

	describe "index" do
		let!(:p1) { FactoryGirl.create(:product, user: user, name: 'Картошка') }
		let!(:p2) { FactoryGirl.create(:product, user: user, name: 'Капуста') }
		before {visit products_path}

		it { should have_title(full_title('Продукты')) }

		it { should have_button('Добавить') }
		it { should have_link('удалить', href: product_path(p1)) }
		it { should have_link('изменить', href: edit_product_path(p1)) }

		describe "on all products" do
			it { should have_content("Все (#{user.products.count})") }

			it "should list each product" do
				user.products.each do |product|
					expect(page).to have_selector('li', text: product.name)
				end
			end
		end
		
		describe "on available products" do
			before do
				p1.update_attribute(:available, true)
				visit products_path
			end
			it { should have_content("В наличии (#{user.available_products.count})") }

			it "should list each product" do
				user.available_products.each do |product|
					expect(page).to have_selector('li', text: product.name)
				end
			end
		end

	end

end

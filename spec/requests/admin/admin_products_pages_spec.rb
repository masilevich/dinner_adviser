require 'spec_helper'
require 'shared_stuff'

describe "Admin::ProductsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!
	include_context "login user"
	include_context "CRUD buttons and links names"
	let(:create_button) { "Создать Продукт" }
	let(:save_button) { "Сохранить Продукт" }

	let(:admin) {FactoryGirl.create(:admin)}
	before do
		login_as(admin, :scope => :user)
	end

	subject { page }

	let(:product_name) { "Жареная курица" }

	describe "index" do
		let!(:cp1) { FactoryGirl.create(:common_product) }
		let!(:cp2) { FactoryGirl.create(:common_product) }
		before {visit admin_products_path}

		it { should have_title(full_title('Базовые продукты')) }
		it { should have_link('Базовые продукты', href: admin_products_path) }

		it { should have_link(add_button, href: new_admin_product_path) }
		it { should have_link(delete_link, href: admin_product_path(cp1)) }
		it { should have_link(cp1.name, href: admin_product_path(cp1)) }
		it { should have_link(cp2.name, href: admin_product_path(cp2)) }

		describe "on all products" do
			it { should have_content("Все (#{Product.common.count})") }

			it "should list each product" do
				Product.common.each do |product|
					expect(page).to have_selector('td', text: product.name)
				end
			end

		end
	end

	describe "creation" do
		before {visit new_admin_product_path}

		it { should have_title(full_title('Новый базовый продукт')) }
		it { should have_link('Базовые продукты', href: admin_products_path) }

		describe "with invalid information" do

			it "should not create a product" do
				expect { click_button create_button }.not_to change(Product, :count)
			end

			describe "render" do
				before { click_button create_button }

				describe "error messages" do
					before { click_button create_button }
					it { should have_error_message('Продукт не добавлен') }
				end

				describe "right action" do
					it { should have_title(full_title('Новый базовый продукт')) }
				end
			end
		end

		describe "with valid information" do
			before {fill_in 'product_name', with: product_name }

			describe "after save" do
				before do
					fill_in 'product_name', with: product_name
					click_button create_button
					@product = Product.find_by_name(product_name)
				end

				specify {expect(@product.common).to be_true}

			end

			it "should create a product" do
				expect { click_button create_button }.to change(Product.common, :count).by(1)
			end

		end
	end

	describe "edit" do
		let!(:product) {FactoryGirl.create(:common_product)}
		before {visit edit_admin_product_path(product) }

		it { should have_title(full_title('Изменить базовый продукт')) }

		describe "after save" do
			before do
				fill_in "product_name", with: product_name
				click_button save_button
				product.reload
			end
			it "should update a product" do
				expect(product.name).to eq product_name
			end

			it { should have_content(product_name) }

			it { should have_content("Базовый продукт изменен") }
			it { should have_title(full_title('Базовые продукт')) }
		end

		describe "with invalid information" do

			before do
				fill_in "product_name", with: ""
				click_button save_button
			end

			describe "error messages" do
				it { should have_error_message('Базовый продукт не изменен') }
			end

			describe " render right action" do
				it { should have_title(full_title('Изменить базовый продукт')) }
			end
		end
	end

	describe "destruction" do
		let!(:product) {FactoryGirl.create(:common_product)}
		describe "in products controller pages" do

			before { visit admin_products_path }
			it "delete a product" do
				expect { click_link delete_link }.to change(Product, :count).by(-1)
			end

			describe "have link to destroy" do
				specify {expect(page).to have_link(delete_link, admin_product_path(product))}
			end
		end
	end

	describe "show" do
		let!(:product) {FactoryGirl.create(:common_product)}
		before do
			visit admin_product_path(product)
		end	

		it { should have_title(full_title('Базовый продукт')) }

		it { should have_link('Изменить', href: edit_admin_product_path(product)) }
		it { should have_content(product.name)}
	end
end

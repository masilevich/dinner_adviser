require 'spec_helper'
require 'shared_stuff'
require 'import_common_shared_examples'
require 'user_helper'

describe "ProductsPages" do

	include_context "login user"
	include_context "CRUD buttons and links names"

	let(:product_name) { "Жареная курица" }
	let(:create_button) { "Создать Продукт" }
	let(:save_button) { "Сохранить Продукт" }

	describe "creation" do
		before {visit new_product_path}
		describe "with invalid information" do

			it "should not create a product" do
				expect { click_button create_button }.not_to change(Product, :count)
			end

			describe "error messages" do
				before { click_button create_button }
				it { should have_error_message('Продукт не добавлен') }

				describe "after visiting another page" do
					before { click_link "Главная" }
					it { should_not have_selector('div.alert.alert-warning') }
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

				specify {expect(@product.available).to be_false}

				it "should not contain product_categories" do
					expect(@product.category).to be_nil
				end
			end

			it "should create a product" do
				expect { click_button create_button }.to change(Product, :count).by(1)
			end


			describe "and product_category select" do
				let!(:pk1) { FactoryGirl.create(:product_category, user: user) }
				before do
					visit new_product_path
					fill_in 'product_name', with: product_name
					select pk1.name, :from => "product_category_id"
					click_button create_button
				end
				it "should contain product_category" do
					expect(Product.find_by_name(product_name).category).to eq pk1
				end
			end

		end
	end

	describe "destruction" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		describe "in products controller pages" do

			before { visit products_path }
			it "delete a product" do
				expect { click_link delete_link }.to change(Product, :count).by(-1)
			end

			describe "have link to destroy" do
				specify {expect(page).to have_link(delete_link, product_path(product))}
			end
		end

		describe "link only on product contoller pages" do
			let!(:c1) { FactoryGirl.create(:course, user: user) }
			before do
				c1.products << product
				visit course_path(c1)
			end	
			specify {expect(page).to_not have_link(delete_link, href: product_path(product))}
		end
	end

	describe "edit" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		let!(:pk1) { FactoryGirl.create(:product_category, user: user) }
		before {visit edit_product_path(product) }

		it { should have_select('product_category_id', :options => ['',pk1.name]) }

		describe "after save" do
			before do
				fill_in "product_name", with: product_name
				select pk1.name, :from => "product_category_id"
				click_button save_button
				product.reload
			end
			it "should update a product" do
				expect(product.name).to eq product_name
			end

			it { should have_content(product_name) }

			it { should have_content("Продукт изменен") }

			it "product should contain product_category" do
				expect(product.category).to eq pk1
			end
		end
	end

	describe "index" do
		let!(:p1) { FactoryGirl.create(:product, user: user) }
		let!(:p2) { FactoryGirl.create(:product, user: user) }
		before {visit products_path}

		it { should have_title(full_title('Продукты')) }

		it { should have_link(add_button, href: new_product_path) }
		it { should have_link(delete_link, href: product_path(p1)) }
		it { should have_link(p1.name, href: product_path(p1)) }
		it { should have_link(p2.name, href: product_path(p2)) }

		it { should have_link("Виды продуктов", href: product_categories_path) }
		it { should have_link("Импорт базовых продуктов", href: import_common_products_path) }

		describe "on all products" do
			it { should have_content("Все (#{user.products.count})") }

			it "should list each product" do
				user.products.each do |product|
					within('#products') do
						expect(page).to have_selector('td', text: product.name)
					end
				end
			end

			describe "with categories" do
				let!(:pk) { FactoryGirl.create(:product_category, user: user) }
				before do
					p1.category = pk
					visit products_path
				end
				it "should list each category" do
					within('#products') do
						ProductCategory.categories_for_products(user.products).each do |product_category|
							expect(page).to have_selector('h4', text: product_category.name)
						end
					end
				end

				it "should list empty category" do
					expect(page).to have_selector('h4', text: "Без категории")
				end
			end
		end

		describe "on available products" do
			before do
				p1.update_attribute(:available, true)
				visit products_path
			end
			it { should have_content("В наличии (#{user.products.availabled.count})") }

			it "should list each product" do
				user.products.availabled.each do |product|
					within('#products_availabled') do
						expect(page).to have_selector('td', text: product.name)
					end
				end
			end

			describe "with categories" do
				let!(:pk) { FactoryGirl.create(:product_category, user: user) }
				before do
					p1.category = pk
					visit products_path
				end
				it "should list each category" do
					within('#products_availabled') do
						ProductCategory.categories_for_products(user.products.availabled).each do |product_category|
							expect(page).to have_selector('h4', text: product_category.name)
						end
					end
				end
			end
		end
	end

	describe "manipulation", js: true  do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		before { visit products_path }

		describe "mark available" do
			before {first(:checkbox, "product_chckbox_#{product.id}").click}
			it "should make product available" do
				visit products_path
				expect(product.reload).to be_available
			end

			it "should take product to available list" do
				visit products_path
				within('#products_availabled') do
					expect(page).to have_selector('td', text: product.name)
				end
			end
		end

		describe "mark unavailable" do
			before do
				product.update_attribute(:available, true)
				visit products_path
				first(:checkbox, "product_chckbox_#{product.id}").click
			end
			it "should make product unavailable" do
				visit products_path
				expect(product.reload).to_not be_available
			end
		end
	end

	describe "show" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		before do
			visit product_path(product)
		end	

		it { should have_title(full_title('Продукт')) }

		it { should have_link('Изменить', href: edit_product_path(product)) }
		it { should have_content(product.name)}
	end

	it_should_behave_like "import common products" do
		let(:import_path) { import_common_products_path }
	end
end

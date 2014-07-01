require 'spec_helper'

describe "ProductsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	describe "creation" do
		before {visit new_product_path}
		describe "with invalid information" do

			it "should not create a product" do
				expect { click_button "Добавить" }.not_to change(Product, :count)
			end

			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_error_message('Продукт не добавлен') }

				describe "after visiting another page" do
					before { click_link "Главная" }
					it { should_not have_selector('div.alert.alert-warning') }
				end
			end
		end

		describe "with valid information" do
			before {fill_in 'product_name', with: "Жареная курица" }

			describe "after save" do
				before do
					fill_in 'product_name', with: "Жареная курица"
					click_button "Добавить"
					@product = Product.find_by_name("Жареная курица")
				end

				specify {expect(@product.available).to be_false}

				it "should not contain product_kinds" do
					expect(@product.product_kind).to be_nil
				end
			end

			it "should create a product" do
				expect { click_button "Добавить" }.to change(Product, :count).by(1)
			end


			describe "and product_kind select" do
				let!(:pk1) { FactoryGirl.create(:product_kind, user: user, name: "Овощи") }
				before do
					visit new_product_path
					fill_in 'product_name', with: "Жареная курица"
					select pk1.name, :from => "product_product_kind_id"
					click_button "Добавить"
				end
				it "should contain product_kind" do
					expect(Product.find_by_name("Жареная курица").product_kind).to eq pk1
				end
			end

		end

	end

	describe "destruction" do
		let!(:product) {FactoryGirl.create(:product,user: user)}
		describe "in products controller pages" do

			before { visit products_path }
			it "should delete a product" do
				expect { click_link "удалить" }.to change(Product, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link("удалить", product_path(product))}
			end
		end

		describe "link should be only on product contoller pages" do
			let!(:c1) { FactoryGirl.create(:course, user: user, name: 'Пюре') }
			before do
				c1.products << product
				visit course_path(c1)
			end	
			specify {expect(page).to_not have_link("удалить", href: product_path(product))}
		end
	end

	describe "edit" do
		let!(:product) {FactoryGirl.create(:product,user: user, name: "Огурцы")}
		let!(:pk1) { FactoryGirl.create(:product_kind, user: user, name: 'Овощи') }
		before {visit edit_product_path(product) }

		it { should have_select('product_product_kind_id', :options => ['',pk1.name]) }

		describe "after save" do
			before do
				fill_in "product_name", with: "Картошка"
				select pk1.name, :from => "product_product_kind_id"
				click_button "Сохранить"
				product.reload
			end
			it "should update a product" do
				expect(product.name).to eq "Картошка"
			end

			it { should have_content("Картошка") }

			it { should have_content("Продукт изменен") }

			it "product should contain product_kind" do
				expect(product.product_kind).to eq pk1
			end
		end
		
	end

	describe "index" do
		let!(:p1) { FactoryGirl.create(:product, user: user, name: 'Картошка') }
		let!(:p2) { FactoryGirl.create(:product, user: user, name: 'Капуста') }
		before {visit products_path}

		it { should have_title(full_title('Продукты')) }

		it { should have_link('Добавить', href: new_product_path) }
		it { should have_link('удалить', href: product_path(p1)) }
		it { should have_link(p1.name, href: edit_product_path(p1)) }
		it { should have_link(p2.name, href: edit_product_path(p2)) }

		it { should have_link("Виды продуктов", href: product_kinds_path) }

		describe "on all products" do
			it { should have_content("Все (#{user.products.count})") }

			it "should list each product" do
				user.products.each do |product|
					within('#products') do
						expect(page).to have_selector('td', text: product.name)
					end
				end
			end

			describe "with kinds" do
				let!(:pk) { FactoryGirl.create(:product_kind, user: user) }
				before do
					p1.product_kind = pk
					visit products_path
				end
				it "should list each kind" do
					within('#products') do
						ProductKind.kinds_for_products(user.products).each do |product_kind|
							expect(page).to have_selector('h4', text: product_kind.name)
						end
					end
				end

				it "should list empty kind" do
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

			describe "with kinds" do
				let!(:pk) { FactoryGirl.create(:product_kind, user: user) }
				before do
					p1.product_kind = pk
					visit products_path
				end
				it "should list each kind" do
					within('#products_availabled') do
						ProductKind.kinds_for_products(user.products.availabled).each do |product_kind|
							expect(page).to have_selector('h4', text: product_kind.name)
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

end

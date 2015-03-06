shared_examples "import common products" do

	let!(:cp1) { FactoryGirl.create(:common_product) }
	let!(:cp2) { FactoryGirl.create(:common_product) }
	let!(:p1) { FactoryGirl.create(:product, user: user, name: cp1.name) }


	before do
		visit import_path
	end	

	it { should have_title(full_title('Импорт базовых продуктов')) }
	it { should have_content("Базовые продукты (#{user.common_exclude_self_products.count})") }
	it { should have_button('Импорт') }

	it "should list each common product exclude user products" do
		user.common_exclude_self_products.each do |product|
			expect(page).to have_selector('td', text: product.name)
		end
	end

	it "should not list user products" do
		user.products.each do |product|
			expect(page).to_not have_selector('td', text: product.name)
		end
	end

	describe "submit" do
		describe "with product check" do
			before do
				user.common_exclude_self_products.each do |product|  
					check "product_chckbox_#{product.id}"
				end
				@imported_products = user.common_exclude_self_products.to_a
				click_button "Импорт"
			end

			it "should add products to user products" do
				@imported_products.each do |product| 
					expect(user.products.find_by(name: product.name)).to_not be_nil 
				end	
			end
		end

		it_should_behave_like "with blank check"

	end
end

shared_examples "import common courses" do
	let!(:cc1) { FactoryGirl.create(:common_course) }
	let!(:cc2) { FactoryGirl.create(:common_course) }

	before do
		visit import_path
	end	

	it { should have_title(full_title('Импорт типовых рецептов')) }
	it { should have_button('Импорт') }

	describe "list" do
		let!(:course_with_common_name) { FactoryGirl.create(:course, user: user, name: cc1.name) }
		before {visit import_common_courses_path}
		it { should have_content("Типовые рецепты (#{user.common_exclude_self_courses.count})") }

		it "each common course exclude user courses" do
			user.common_exclude_self_courses.each do |course|
				expect(page).to have_selector('td', text: course.name)
			end
		end

		it "should not show user courses" do
			user.courses.each do |course|
				expect(page).to_not have_selector('td', text: course.name)
			end
		end

		describe "course with ingridients" do
			let!(:course_with_products) { FactoryGirl.create(:common_course_with_products) }
			before {visit import_common_courses_path}
			specify do 
				course_with_products.products.each do |product|  
					expect(page).to have_link(product.name, href: product_path(product)) 
				end
			end
		end
	end

	describe "submit" do
		describe "with course check" do
			before do
				user.common_exclude_self_courses.each do |course|  
					check "course_chckbox_#{course.id}"
				end
				@imported_courses = user.common_exclude_self_courses.to_a
				click_button "Импорт"
			end
			it "should add courses to user courses" do
				@imported_courses.each do |course| 
					expect(user.courses.find_by(name: course.name)).to_not be_nil 
				end	
			end
		end

		it_should_behave_like "with blank check"
	end

	describe "with products" do
		let!(:cp1) { FactoryGirl.create(:common_product) }
		let!(:cp2) { FactoryGirl.create(:common_product) }
		let!(:p1) { FactoryGirl.create(:product, user: user, name: cp1.name) }
		before do
			cc1.products << cp1
			cc1.products << cp2
			cc1.save
			check "course_chckbox_#{cc1.id}"
			click_button "Импорт"
		end

		it "should copy common product to user products" do
			expect(user.products).to_not include(cp1)
			expect(user.courses.find_by(name: cc1.name).products).to include(p1)
			expect(user.products.find_by(name: cp2.name)).to_not be_nil
		end

	end
end

shared_examples "with blank check" do
	specify { expect {click_button "Импорт"}.to_not raise_error }	
end
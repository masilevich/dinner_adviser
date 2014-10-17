require 'spec_helper'
require 'shared_food'

describe Menu do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@menu = user.menus.build(date: Time.now())
	end

	subject { @menu }

	it { should respond_to(:date) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:category) }
	it { should respond_to(:category_id) }
	it { should respond_to(:courses) }
	it { should respond_to(:products) }

	its(:user) { should eq user }

	it { should be_valid }

	describe "validation" do

		describe "with blank date" do
			before {@menu.date = nil}
			it { should_not be_valid }
		end

	end

	describe "order" do

		let!(:m3) { FactoryGirl.create(:menu, date: (Time.now-2.days)) }
		let!(:m2) { FactoryGirl.create(:menu, date: (Time.now-1.days)) }
		let!(:m1) { FactoryGirl.create(:menu, date: Time.now) }

		it "should have rights menus in right order" do
			expect(Menu.all.to_a).to eq [m1, m2, m3]
		end
	end


	describe "without_category" do
		
	  it "scope should include menu without category" do
	  	@menu.save
			expect(Menu.without_category).to include(@menu)
		end

		describe "scope should not include menu with category" do
			let(:menu_category) { FactoryGirl.create(:menu_category) }
			before do
			  @menu.category = menu_category
			  @menu.save
			end 
			specify { expect(Course.without_category).to_not include(@menu) }
		end

	end

	describe "products" do
		include_context "course and two products"
	  before do
	  	course.products << p1
	  	course.products << p2
	  	@menu.courses << course
	  	@menu.save
	  end
	  it "should include course products" do
	  	expect(@menu.products).to include(p1) 
	  	expect(@menu.products).to include(p2) 
	  end
	  it "not enough and enough" do
	  	expect(@menu.products.enough).to include(p1) 
	  	expect(@menu.products.not_enough).to include(p2) 
	  end
	end
end

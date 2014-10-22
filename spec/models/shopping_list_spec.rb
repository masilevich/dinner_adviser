require 'spec_helper'
require 'shared_food'

describe ShoppingList do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@shopping_list = user.shopping_lists.build(name: "Список покупок на выходные")
	end

	subject { @shopping_list }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:products) }

	it { should be_valid }

	its(:user) { should eq user }

	describe "validation" do

		describe "with blank name" do
			before {@shopping_list.name = nil}
			it { should_not be_valid }
		end

		describe "when user_id is not present" do
			before { @shopping_list.user_id = nil }
			it { should_not be_valid }
		end

		describe "with name that is too long" do
			before { @shopping_list.name = "a" * 101 }
			it { should_not be_valid }
		end
	end

	describe "order" do

		let!(:sl3) { FactoryGirl.create(:shopping_list, name: "c") }
		let!(:sl2) { FactoryGirl.create(:shopping_list, name: "b") }
		let!(:sl1) { FactoryGirl.create(:shopping_list, name: "a") }

		it "should have rights menus in right order" do
			expect(ShoppingList.all.to_a).to eq [sl1, sl2, sl3]
		end
	end

	describe "products association" do
		include_context "two products"
	  before do
	  	@shopping_list.products << p1
	  	@shopping_list.products << p2
	  	@shopping_list
	  end
	  it "should include products" do
	  	expect(@shopping_list.products).to include(p1) 
	  	expect(@shopping_list.products).to include(p2) 
	  end
	end
end

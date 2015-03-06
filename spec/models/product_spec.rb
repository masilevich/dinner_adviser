require 'spec_helper'
require 'shared_food'
require 'models/shared_examples/common_shared_examples'

describe Product do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@product = user.products.build(name: "Молоко")
	end

	subject { @product }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:courses) }
	it { should respond_to(:ingridients) }
	it { should respond_to(:available) }
	it { should respond_to(:category_id) }
	it { should respond_to(:category) }
	it { should respond_to(:shopping_lists) }

	describe "class methods" do
	  subject { Product }
	  it { should respond_to(:availabled) }
	  it { should respond_to(:unavailabled) }
	  it_behaves_like "common"
	  it { should respond_to(:enough) }
	  it { should respond_to(:not_enough) }
	end

	its(:user) { should eq user }

	it { should be_valid }

	describe "validation" do

		describe "with blank name" do
			before {@product.name = ' '}
			it { should_not be_valid }
		end

		describe "with name that is too long" do
			before {@product.name = 'a'*101}
			it { should_not be_valid }
		end
	end

	describe "order" do

		let!(:p3) { FactoryGirl.create(:product, name: 'Картошка') }
		let!(:p2) { FactoryGirl.create(:product, name: 'Банан') }
		let!(:p1) { FactoryGirl.create(:product, name: 'Ананас') }

		it "should have rights products in right order" do
			expect(Product.all.to_a).to eq [p1, p2, p3]
		end
	end

	describe "without_category" do
		
	  it "scope should include product without category" do
	  	@product.save
			expect(Product.without_category).to include(@product)
		end

		describe "scope should not include product with category" do
			let(:product_category) { FactoryGirl.create(:product_category) }
			before do
			  @product.category = product_category
			  @product.save
			end 
			specify { expect(Product.without_category).to_not include(@product) }
		end
	end

	describe "with_category" do
		let(:product_category) { FactoryGirl.create(:product_category) }
	  it "scope should not include product without category" do
	  	@product.save
			expect(Product.with_category(product_category)).to_not include(@product)
		end

		describe "scope should include product with category" do
			before do
			  @product.category = product_category
			  @product.save
			end 
			specify { expect(Product.with_category(product_category)).to include(@product) }
		end
	end

	describe "shopping lists association" do
		include_context "two shopping lists"
	  before do
	  	@product.shopping_lists << sl1
	  	@product.shopping_lists << sl2
	  	@product.save
	  end
	  it "should include shopping lists" do
	  	expect(@product.shopping_lists).to include(sl1) 
	  	expect(@product.shopping_lists).to include(sl2) 
	  end
	end

	describe "common" do
		let!(:common_product) { FactoryGirl.create(:common_product) }
	  specify{ expect(Product.common.to_a).to include(common_product)}
	end

	describe "exclude by name" do
		let!(:common_product) { FactoryGirl.create(:common_product) }
		let!(:user_product) { FactoryGirl.create(:product, user: user, name: common_product.name) }
	  specify{ expect(Product.common_exclude_by_name(user.products).find_by(name: common_product.name)).to be_nil}
	end
end

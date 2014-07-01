require 'spec_helper'

describe Product do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@product = user.products.build(name: "Молоко")
		@common_product = Product.new(name: "Сыр", common: true)
	end

	subject { @product }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:courses) }
	it { should respond_to(:ingridients) }
	it { should respond_to(:available) }
	it { should respond_to(:product_kind_id) }
	it { should respond_to(:product_kind) }

	it "should respond to availabled" do
		expect(Product).to respond_to(:availabled)
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

	describe "without_kind" do
		
	  it "scope should include product without kind" do
	  	@product.save
			expect(Product.without_kind).to include(@product)
		end

		describe "scope should not include product with kind" do
			let(:product_kind) { FactoryGirl.create(:product_kind) }
			before do
			  @product.product_kind = product_kind
			  @product.save
			end 
			specify { expect(Course.without_kind).to_not include(@product) }
		end

	end
end

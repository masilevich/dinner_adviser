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
end

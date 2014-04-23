require 'spec_helper'

describe Ingridient do
  let(:user) { FactoryGirl.create(:user) }
  let(:product) { user.products.create(name: "Молоко") }
  let(:course) { user.courses.create(name: "Макароны") }
  let(:ingridient) { course.ingridients.build(product_id: product.id) }

	subject { ingridient }

	it { should respond_to(:product) }
	it { should respond_to(:course) }
	its(:product) { should eq product}
  its(:course) { should eq course}

	it { should be_valid }

	describe "validation" do

		describe "when product is not present" do
			before {ingridient.product_id = nil}
			it { should_not be_valid }
		end

		describe "when course is not present" do
			before {ingridient.course_id = nil}
			it { should_not be_valid }
		end
	end
end

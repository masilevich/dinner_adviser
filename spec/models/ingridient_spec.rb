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

end

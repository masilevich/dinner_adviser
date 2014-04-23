require 'spec_helper'

describe Course do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@course = user.courses.build(name: "Макароны")
		@common_course = Course.new(name: "Пюре", common: true)
	end

	subject { @course }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:course_kind_id) }
	it { should respond_to(:course_kind) }
	it { should respond_to(:products) }
	it { should respond_to(:ingridients) }
	its(:user) { should eq user }

	it { should be_valid }

	describe "validation" do

		describe "with blank name" do
			before {@course.name = ' '}
			it { should_not be_valid }
		end

		describe "with name that is too long" do
			before {@course.name = 'a'*101}
			it { should_not be_valid }
		end
	end
end

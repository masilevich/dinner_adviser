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
	it { should respond_to(:menus) }

	it "should respond to availabled" do
		expect(Course).to respond_to(:availabled)
	end
	it "should respond to without_kind" do
		expect(Course).to respond_to(:without_kind)
	end
	
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

	describe "availabled" do
		before do
			@course.products = []
			@course.save
		end
		it "should not include course without products" do
			expect(Course.availabled).to_not include(@course)
		end

		describe "with" do
			before do
				@p1 = user.products.create(name: "p1")
				@p2 = user.products.create(name: "p2")
				@course.products << @p1
				@course.products << @p2
			end

			describe "unavailable products" do
				before do
					@p1.update_attribute(:available, false)
					@p2.update_attribute(:available, false)
				end
				specify { expect(Course.availabled).to_not include(@course)}
			end

			describe "one available and one unavailable products" do
				before do
					@p1.update_attribute(:available, true)
					@p2.update_attribute(:available, false)
				end
				specify { expect(Course.availabled).to_not include(@course)}
			end

			describe "two available products" do
				before do
					@p1.update_attribute(:available, true)
					@p2.update_attribute(:available, true)
				end
				specify { expect(Course.availabled).to include(@course)}
			end

		end
	end

	describe "without_kind" do
		
	  it "scope should include course without kind" do
	  	@course.save
			expect(Course.without_kind).to include(@course)
		end

		describe "scope should not include course with kind" do
			let(:course_kind) { FactoryGirl.create(:course_kind) }
			before do
			  @course.course_kind = course_kind
			  @course.save
			end 
			specify { expect(Course.without_kind).to_not include(@course) }
		end

	end

	describe "order" do

		let!(:c3) { FactoryGirl.create(:course, name: 'Пюре') }
		let!(:c2) { FactoryGirl.create(:course, name: 'Курица') }
		let!(:c1) { FactoryGirl.create(:course, name: 'Жаркое') }

		it "should have rights products in right order" do
			expect(Course.all.to_a).to eq [c1, c2, c3]
		end
	end
end

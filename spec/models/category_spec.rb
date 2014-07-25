require 'spec_helper'

describe Category do
	CATEGORY_TYPES = ["ProductCategory", "CourseCategory", "MenuCategory"]
	before do
		@category = Category.new(name: "Категория")

	end

	subject { @category }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:type) }

	it { should be_valid }

	describe "validation" do

		describe "with blank name" do
			before {@category.name = ' '}
			it { should_not be_valid }
		end

		describe "with name that is too long" do
			before {@category.name = 'a'*51}
			it { should_not be_valid }
		end
	end

	describe "order" do

		let!(:c3) { FactoryGirl.create(:category, name: 'В категория') }
		let!(:c2) { FactoryGirl.create(:category, name: 'Б категория') }
		let!(:c1) { FactoryGirl.create(:category, name: 'А категория') }

		it "should have rights categories in right order" do
			expect(Category.all.to_a).to eq [c1, c2, c3]
		end
	end


	CATEGORY_TYPES.each do |s|
		describe "for #{s} scope" do
			before {@sub_category = s.constantize.create(name: s)}
			specify { expect(Category.send(s.tableize)).to include(@sub_category)}
		end

		describe "subclasses creation" do
			before {@sub_class = Category.create(name: s, type: s)}
			specify { expect(@sub_class).to be_kind_of s.constantize}
		end

	end
end

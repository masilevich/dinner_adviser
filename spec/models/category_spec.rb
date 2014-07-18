require 'spec_helper'

describe Category do
	CATEGORY_TYPES = ["Product", "Course", "Menu"]
	before do
		@category = Category.new(name: "Категория")

	end

	subject { @category }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }

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


	describe "for" do
		CATEGORY_TYPES.each do |s|
			category_type = s + described_class.name
			describe "#{s} scope" do
				before {@sub_category = category_type.constantize.create(name: s)}
				specify { expect(Category.send(category_type.tableize)).to include(@sub_category)}
			end
		end
	end

end

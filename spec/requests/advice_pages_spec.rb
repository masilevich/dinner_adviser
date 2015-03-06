require 'spec_helper'
require 'user_helper'

describe "AdvicePages" do
	include_context "login user"

	subject { page }

	let!(:course) { FactoryGirl.create(:course, user: user) }
	let!(:category1) { FactoryGirl.create(:course_category, user: user, name: "a") }
	let!(:category2) { FactoryGirl.create(:course_category, user: user, name: "b") }

	describe "get advice" do
		before {visit advice_path}

		it { should have_title(full_title('Случайный рецепт')) }
		it { should have_content(course.name) }
		it { should have_button("Следующий")}
		it { should have_select('course_type', :options => ['Все', 'Доступные для приготовления']) }
		it { should have_select('course_category', :options => ['Все', category1.name, category2.name]) }

		describe "from empty category" do
			before do
				select category1.name, :from => "course_category"
				click_button "Следующий"
			end
		  it { should have_content "Нет рецептов" }
		end

		describe "with category" do
		  let!(:course_with_category) { FactoryGirl.create(:course, user: user, category: category1) }
		 	before do
		 	  select category1.name, :from => "course_category"
				click_button "Следующий"
		 	end
		 	it { should have_content(course_with_category.name) }
		end

		describe "dont repeat twice one course" do
		  let!(:another_course) { FactoryGirl.create(:course, user: user) }
		 	specify do
		 	  10.times do |i|
		 	    expect(page).to have_content([course.name, another_course.name][i])
		 	    click_button "Следующий"
		 	  end
		 	end
		end

		describe "with select availabled type" do
			let!(:available_course) { FactoryGirl.create(:course_with_available_product, user: user) }
		  before do
		 	  select 'Доступные для приготовления', :from => "course_type"
				click_button "Следующий"
		 	end
		 	it "should take course from user availabled courses" do
		 	  expect(page).to have_content(available_course.name)
		 	  select 'Все', :from => "course_type"
				click_button "Следующий"
				expect(page).to have_content(course.name)
		 	end
		end
	end

end

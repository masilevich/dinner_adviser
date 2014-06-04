require 'spec_helper'

describe "AdvicePages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	let!(:available_course) { FactoryGirl.create(:course_with_available_product, user: user,
		name: "available course") }
	let!(:unavailable_course) { FactoryGirl.create(:course_with_unavailable_product, user: user,
		name: "unavailable course") }
	before {login_as(user, :scope => :user)}

	describe "get advice" do
		before {visit advice_path}

		it { should have_title(full_title('Подобрать рецепт')) }
		it { should have_content(available_course.name) }
		it { should_not have_content(unavailable_course.name) }
		it {should have_link("Получить другой", href: advice_path)}

		describe "should have only available course after update page" do
			before { visit advice_path }
			it { should have_content(available_course.name) }
			it { should_not have_content(unavailable_course.name) }
		end
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "Подобрать рецепт"
		expect(page).to have_title(full_title('Подобрать рецепт'))
		click_link "Продукты"
		expect(page).to have_title(full_title('Продукты'))
		click_link "Мои рецепты"
		expect(page).to have_title( full_title('Мои рецепты'))
		click_link "Обеденный советник"
		expect(page).to have_title( full_title(''))
	end
end

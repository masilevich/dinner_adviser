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

		it { should have_content(available_course.name) }
		it { should_not have_content(unavailable_course.name) }

		describe "should have only available course after update page" do
			before { visit advice_path }
			it { should have_content(available_course.name) }
			it { should_not have_content(unavailable_course.name) }
		end
	end

end

require 'spec_helper'

describe "AdvicePages" do
  include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}
end

shared_context "login user" do
	include Warden::Test::Helpers
	Warden.test_mode!
	
	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}
	subject { page }
end
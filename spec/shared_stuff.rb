shared_context "CRUD buttons and links names" do
	let(:save_button) { "Сохранить" }
	let(:add_button) { "Добавить" }
	let(:delete_link) { 'удалить' }
	let(:change_link) { 'Изменить' }
end

shared_context "login user" do
	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}
	subject { page }
end
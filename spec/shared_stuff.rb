shared_context "shared stuff" do
  let(:user) { FactoryGirl.create(:confirmed_user) }
	let(:save_button) { "Сохранить" }
	let(:add_button) { "Добавить" }
	let(:delete_link) { 'удалить' }
	let(:change_link) { 'Изменить' }
	before {login_as(user, :scope => :user)}
	subject { page }
end
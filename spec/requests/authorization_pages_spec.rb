require 'spec_helper'

describe "authorization" do
  include Warden::Test::Helpers
  Warden.test_mode!
  after(:each) { Warden.test_reset! }

  subject { page }

  shared_examples_for "Signin page" do
    it { should have_title('Войти') }
  end

  shared_examples_for "Redirect to signin page" do
    it "should redirect_to sign page" do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  shared_examples_for "Redirect to root" do
    it "should redirect_to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  describe "for non signed users" do
    let(:user) { FactoryGirl.create(:user) }

    describe "in the Products controller" do

      describe "submitting to the index action" do
        before { get products_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the create action" do
        before { post products_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the edit action" do
        before { get edit_product_path(FactoryGirl.create(:product)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the update action" do
        before { patch product_path(FactoryGirl.create(:product)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the destroy action" do
        before { delete product_path(FactoryGirl.create(:product)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the set_availability action" do
        before { put set_availability_product_path(FactoryGirl.create(:product),product: {available: true}) }
        it_should_behave_like "Redirect to signin page"
      end
    end

    describe "in the Courses controller" do

      describe "submitting to the new action" do
        before { get new_course_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the index action" do
        before { get courses_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the create action" do
        before { post courses_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the edit action" do
        before { get edit_course_path(FactoryGirl.create(:course)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the update action" do
        before { patch course_path(FactoryGirl.create(:course)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the destroy action" do
        before { delete course_path(FactoryGirl.create(:course)) }
        it_should_behave_like "Redirect to signin page"
      end
    end

    describe "in the Categories controller" do

      describe "submitting to the index action" do
        before { get categories_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the create action" do
        before { post categories_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the edit action" do
        before { get edit_category_path(FactoryGirl.create(:category)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the update action" do
        before { patch category_path(FactoryGirl.create(:category)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the destroy action" do
        before { delete category_path(FactoryGirl.create(:category)) }
        it_should_behave_like "Redirect to signin page"
      end

    end

    describe "in the Advices controller" do

      describe "submitting to the new action" do
        before { get advice_path }
        it_should_behave_like "Redirect to signin page"
      end
    end

    describe "in the Menus controller" do

      describe "submitting to the new action" do
        before { get new_menu_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the index action" do
        before { get menus_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the create action" do
        before { post menus_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the edit action" do
        before { get edit_menu_path(FactoryGirl.create(:menu)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the update action" do
        before { patch menu_path(FactoryGirl.create(:menu)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the destroy action" do
        before { delete menu_path(FactoryGirl.create(:menu)) }
        it_should_behave_like "Redirect to signin page"
      end
    end

    describe "in the ShoppingLists controller" do

      describe "submitting to the new action" do
        before { get new_shopping_list_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the index action" do
        before { get shopping_lists_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the create action" do
        before { post shopping_lists_path }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the edit action" do
        before { get edit_shopping_list_path(FactoryGirl.create(:shopping_list)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the update action" do
        before { patch shopping_list_path(FactoryGirl.create(:shopping_list)) }
        it_should_behave_like "Redirect to signin page"
      end

      describe "submitting to the destroy action" do
        before { delete shopping_list_path(FactoryGirl.create(:shopping_list)) }
        it_should_behave_like "Redirect to signin page"
      end
    end

  end

  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    
    let(:wrong_user) { FactoryGirl.create(:confirmed_user, email: "wrong@example.com") }
    before do
      login_as(wrong_user, :scope => :user)
    end

    describe "in the Products controller" do
      let!(:product) {FactoryGirl.create(:product,user: user)}

      describe "submitting to the edit action" do
        before { get edit_product_path(product) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the update action" do
        before { patch product_path(product) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the destroy action" do
        before { delete product_path(product) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the set_availability action" do
        before { put set_availability_product_path(product,product: {available: true}) }
        it_should_behave_like "Redirect to root"
      end
    end

    describe "in the Courses controller" do
      let!(:course) {FactoryGirl.create(:course,user: user)}

      describe "submitting to the edit action" do
        before { get edit_course_path(course) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the update action" do
        before { patch course_path(course) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the destroy action" do
        before { delete course_path(course) }
        it_should_behave_like "Redirect to root"
      end
    end

    describe "in the Categories controller" do
      let!(:category) {FactoryGirl.create(:category,user: user)}

      describe "submitting to the edit action" do
        before { get edit_category_path(category) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the update action" do
        before { patch category_path(category) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the destroy action" do
        before { delete category_path(category) }
        it_should_behave_like "Redirect to root"
      end
    end

    describe "in the Menus controller" do
      let!(:menu) {FactoryGirl.create(:menu,user: user)}

      describe "submitting to the edit action" do
        before { get edit_menu_path(menu) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the update action" do
        before { patch menu_path(menu) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the destroy action" do
        before { delete menu_path(menu) }
        it_should_behave_like "Redirect to root"
      end
    end

    describe "in the ShoppingLists controller" do
      let!(:shopping_list) {FactoryGirl.create(:shopping_list,user: user)}

      describe "submitting to the edit action" do
        before { get edit_shopping_list_path(shopping_list) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the update action" do
        before { patch shopping_list_path(shopping_list) }
        it_should_behave_like "Redirect to root"
      end

      describe "submitting to the destroy action" do
        before { delete shopping_list_path(shopping_list) }
        it_should_behave_like "Redirect to root"
      end
    end

  end

=begin
  describe "as non admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin_user) { FactoryGirl.create(:user) }

    before {sign_in non_admin_user, no_capybara: true}
    describe "submitting a DELETE request to the Users#destroy action" do
      before {delete user_path(user)}
      it "redirect to root url" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "as admin user" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin, no_capybara: true
      delete user_path(admin)
    end
    it "should not delete admin user yourself" do
     expect(response).to redirect_to(root_url)
   end
 end
 =end

=begin
 describe "for signed_in users" do
  let(:user) { FactoryGirl.create(:user) }
  before {sign_in user, no_capybara: true}

  describe "submitting users controller new action" do
    before {get new_user_path}
    specify { expect(response).to redirect_to(root_url) }
  end

  describe "submitting users controller create action" do
    let(:params) do
      {user: {full_name: user.full_name, user_name: user.user_name, email: user.email, password: user.password,
        password_confirmation: user.password }}
      end
      before { post users_path, params }
      specify { expect(response).to redirect_to(root_url) }
    end
  end
=end

end
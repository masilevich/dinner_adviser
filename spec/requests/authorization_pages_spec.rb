require 'spec_helper'
require "requests/shared_examples/resource_authorization_pages"

describe "authorization" do

  describe "for standard actions" do

    describe "products" do
      it_should_behave_like "resource with authorization pages" do
        let(:resource_class) { Product }
      end
    end

    describe "courses" do
      it_should_behave_like "resource with authorization pages" do
        let(:resource_class) { Course }
      end
    end

    describe "menus" do
      it_should_behave_like "resource with authorization pages" do
        let(:resource_class) { Menu }
      end
    end

    describe "shopping_lists" do
      it_should_behave_like "resource with authorization pages" do
        let(:resource_class) { ShoppingList }
      end
    end

  end

  describe "for non standard actions" do
    include Warden::Test::Helpers
    Warden.test_mode!
    after(:each) { Warden.test_reset! }

    subject { page }

    describe "for non signed users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Products controller" do

        describe "submitting to the set_availability action" do
          before { put set_availability_product_path(FactoryGirl.create(:product),product: {available: true}) }
          it_should_behave_like "Redirect to signin page"
        end

      end

      describe "in the Advices controller" do

        describe "submitting to the new action" do
          before { get advice_path }
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

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:confirmed_user) }
      
      let(:wrong_user) { FactoryGirl.create(:confirmed_user, email: "wrong@example.com") }
      before do
        login_as(wrong_user, :scope => :user)
      end

      describe "in the Products controller" do
        let!(:product) {FactoryGirl.create(:product,user: user)}

        describe "submitting to the set_availability action" do
          before { put set_availability_product_path(product,product: {available: true}) }
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

    end

  end

=begin
  describe "as non admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin_user) { FactoryGirl.create(:user) }

    before {sign_in non_admin_user, no_capybara: true}
    describe "submitting a DELETE request to the Users#destroy action" do
      before {delete user_path(user)}
      it "Redirect to root url" do
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
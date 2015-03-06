require 'spec_helper'

shared_examples_for "Signin page" do
      it { should have_title('Войти') }
    end

    shared_examples_for "Redirect to signin page" do
      specify do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    shared_examples_for "Redirect to root" do
      specify do
        expect(response).to redirect_to(root_path)
      end
    end

shared_examples "resource with authorization pages" do

  describe "authorization" do
    include Warden::Test::Helpers
    Warden.test_mode!
    after(:each) { Warden.test_reset! }

    subject { page }

    describe "for non signed users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:resource_item) {FactoryGirl.create(resource_class)}

      describe "in the resource controller" do

        describe "submitting to the index action" do
          before { get polymorphic_path(resource_class) }
          it_should_behave_like "Redirect to signin page"
        end

        describe "submitting to the create action" do
          before { post polymorphic_path(resource_class) }
          it_should_behave_like "Redirect to signin page"
        end

        describe "submitting to the show action" do
          before { get polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to signin page"
        end

        describe "submitting to the edit action" do
          before { get edit_polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to signin page"
        end

        describe "submitting to the update action" do
          before { patch polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to signin page"
        end

        describe "submitting to the destroy action" do
          before { delete polymorphic_path(resource_item) }
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

      describe "in the resource controller" do
        let!(:resource_item) {FactoryGirl.create(resource_class, user: user)}

        describe "submitting to the show action" do
          before { get edit_polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to root"
        end

        describe "submitting to the edit action" do
          before { get edit_polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to root"
        end

        describe "submitting to the update action" do
          before { patch polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to root"
        end

        describe "submitting to the destroy action" do
          before { delete polymorphic_path(resource_item) }
          it_should_behave_like "Redirect to root"
        end

      end

    end

  end
end
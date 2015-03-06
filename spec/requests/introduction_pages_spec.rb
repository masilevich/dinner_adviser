require 'spec_helper'
require 'shared_stuff'
require 'requests/shared_examples/import_common_shared_examples'
require 'user_helper'

describe "IntroductionPages" do

	subject { page }

	shared_examples_for "introduction first page" do
		it { should have_title(full_title('Введение')) }
	end

	describe "for signed user" do
		include_context "login user"

		describe "order" do
			let!(:cp) { FactoryGirl.create(:common_product) }
			let!(:cc) { FactoryGirl.create(:common_course) }
			before do
				visit introduction_path
			end

			it_should_behave_like "introduction first page"

			describe "next pages" do
				before {click_link "Далее"}

				specify {expect(page).to have_title(full_title('Импорт базовых продуктов'))}

				describe "through skip link" do
					specify do
						click_link "Пропустить"
						expect(page).to have_title(full_title('Импорт типовых рецептов'))
						click_link "Пропустить"
						expect(page).to have_title(full_title('Случайный рецепт'))
					end
				end

				describe "through import button" do
					specify do
						click_button "Импорт"
						expect(page).to have_title(full_title('Импорт типовых рецептов'))
						click_button "Импорт"
						expect(page).to have_title(full_title('Случайный рецепт'))
					end
				end
			end
		end

		it_should_behave_like "import common products" do
			let(:import_path) { list_common_products_introduction_path }
		end

		it_should_behave_like "import common courses" do
			let(:import_path) { list_common_courses_introduction_path }
		end
	end

	describe "for first time signed in user" do
		let(:user) { FactoryGirl.create(:confirmed_user, password: "foobar", password_confirmation: "foobar") }
		before do
			visit new_user_session_path
			fill_in "user_login", with: user.username
			fill_in "user_password", with: "foobar"
			click_button "Войти"
		end
		it_should_behave_like "introduction first page"
	end
end

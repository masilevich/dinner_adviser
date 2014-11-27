require 'spec_helper'

describe "User pages" do
  include Warden::Test::Helpers
  Warden.test_mode!
  after(:each) { Warden.test_reset! }

  subject { page }

  describe "signin" do
    before do
      logout(:user)
      visit new_user_session_path
    end 

    describe "page" do

      it { should have_selector('h2',    text: 'Войти') }
      it { should have_title(full_title('Войти')) }
    end

    let(:submit) { "Войти" }

    describe "with invalid information" do

      describe "after submission" do
        before { click_button submit }

        it { should have_title(full_title('Войти')) }
        it { should have_link("Регистрация", href: new_user_registration_path) }
        it { should_not have_link("Выход", href: destroy_user_session_path) }
        it { should have_selector('div.alert.alert-alert', text: "Неверный логин или пароль.") }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:confirmed_user) }

      describe "login as email" do
        before do
          fill_in "user_login",     with: user.email
          fill_in "user_password",     with: user.password
          click_button submit
        end
        it { should have_selector('div.alert.alert-notice', 
          text: "Вход в систему выполнен.") }

        it { should_not have_link("Регистрация", href: new_user_registration_path) }
        it { should_not have_link("Войти", href: new_user_session_path) }
        it { should have_link("Профиль", href: edit_user_registration_path(user)) }
        it { should have_link("Выход", href: destroy_user_session_path) }

        describe "followed by signout" do
          before { click_link "Выход" }
          it { should have_link('Войти') }
        end
      end

      describe "login as username" do
        before do
          fill_in "user_login",     with: user.email
          fill_in "user_password",     with: user.password
          click_button submit
        end
        it { should have_selector('div.alert.alert-notice', 
          text: "Вход в систему выполнен.") }
      end
      
      describe "redirect" do

        describe "for first time sign in user" do
          before do
            fill_in "user_login",     with: user.email
            fill_in "user_password",     with: user.password
            click_button submit
          end
          it { should have_title(full_title('Введение')) }
        end

        describe "default" do
          let(:user) { FactoryGirl.create(:confirmed_user,sign_in_count: 2, last_sign_in_at: Time.now) }
          before do
            fill_in "user_login",     with: user.email
            fill_in "user_password",     with: user.password
            click_button submit
          end
          it { should have_title(full_title('Случайный рецепт')) }
        end
        
        
      end
    end
  end

  describe "signup" do

    before { visit new_user_registration_path }

    describe "page" do

      it { should have_selector('h2',    text: 'Регистрация') }
      it { should have_title(full_title('Регистрация')) }
    end

    let(:submit) { "Регистрация" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title(full_title('Регистрация')) }
        it { should have_content('ошибк') }
      end
    end

    describe "with valid information" do
      let(:email) { "user@example.com" }
      before do
        fill_in "user_username",   with: "example_user"
        fill_in "user_email",        with: email
        fill_in "user_password",     with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('div.alert.alert-notice', 
          text: 'В течение нескольких минут вы получите письмо с инструкциями по подтверждению вашей учётной записи') }

        it "should send notification" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [email]
          expect(ActionMailer::Base.deliveries.last.subject).to eq "Инструкции по подтверждению учётной записи"
        end
      end
    end
  end

  describe "profile" do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    before do
      #login_as user
      login_as(user, :scope => :user)
      visit edit_user_registration_path(user)
    end 

    describe "page" do
      it { should have_content("Редактировать профиль") }
      it { should have_title("Редактировать профиль") }
    end

    describe "with valid information" do
      describe "change username and password" do
        let(:new_user_name)  { "new_user_name" }
        let(:new_password) { "newpassword" }
        before do
          fill_in "user_username",        with: new_user_name
          fill_in "user_password",         with: new_password
          fill_in "user_password_confirmation", with: new_password
          fill_in "user_current_password", with: user.password
          click_button "Обновить"
        end
        it { should have_selector('div.alert.alert-notice',
          text: "Ваша учётная запись изменена.") }
        it { should have_link('Выход', href: destroy_user_session_path) }
        specify { expect(user.reload.username).to  eq new_user_name }
      end

      describe "change email" do
        let(:new_email) { "new@example.com" }
        before do
          fill_in "user_email",            with: new_email
          fill_in "user_current_password", with: user.password
          click_button "Обновить"
        end

        it { should have_selector('div.alert.alert-notice',
          text: 'Ваш аккаунт успешно обновлен, нонеобходимо подтвердить ваш новый адрес email. Пожалуйста, проверьте свою электронную почту и нажмите на ссылку "Подтвердить", чтобы завершить обновления email.') }
        it { should have_link('Выход', href: destroy_user_session_path) }

        describe "should be unconfirmed" do
          before {visit edit_user_registration_path(user)}
          it { should have_content("ожидается подтвеждение для: #{new_email}") }
        end

        it "should send notification" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [new_email]
          expect(ActionMailer::Base.deliveries.last.subject).to eq "Инструкции по подтверждению учётной записи"
        end
      end
    end
  end

  describe "resend confirmation instructions" do
    before (:each) {ActionMailer::Base.deliveries.clear}
    describe "for unconfirmed user" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: user.email
        click_button "Выслать"
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq "Инструкции по подтверждению учётной записи"
      end
    end

    describe "for confirmed user" do

      let(:user) { FactoryGirl.create(:confirmed_user) }
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: user.email
        click_button "Выслать"
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    describe "for random email" do
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: "random@example.com"
        click_button "Выслать"
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "reset password instructions" do
    before (:each) {ActionMailer::Base.deliveries.clear}
    describe "for unconfirmed user" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_button "Выслать"
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq "Инструкции по восстановлению пароля"
      end
    end

    describe "for confirmed user" do

      let(:user) { FactoryGirl.create(:confirmed_user) }
      before do
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_button "Выслать"
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq "Инструкции по восстановлению пароля"
      end
    end

    describe "for random email" do
      before do
        visit new_user_password_path
        fill_in "user_email", with: "random@example.com"
        click_button "Выслать"
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

end
require 'spec_helper'

describe "Static pages" do
  include Warden::Test::Helpers
  Warden.test_mode!

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Добро пожаловать к обеденному советнику' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title(full_title('Home'))  }

    describe "for not signed-in users" do
      before {visit root_path}
      it { should have_link("Регистрация", href: new_user_registration_path) }
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:confirmed_user) }
      before do
        login_as(user, :scope => :user)
        visit root_path
      end
      after {Warden.test_reset! }

      it { should_not have_link("Регистрация", href: new_user_registration_path) }

      describe "food links" do
        it { should have_link("Случайный рецепт", href: advice_path) }
        it { should have_link("Продукты", href: products_path) }
        it { should have_link("Мои рецепты", href: courses_path) }
        it { should have_link("Меню", href: menus_path) }
        it { should have_link("Списки покупок", href: shopping_lists_path) }
      end
    end
    
  end


  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'О нас' }
    let(:page_title) { 'О нас' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Контакты' }
    let(:page_title) { 'Контакты' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "О нас"
    expect(page).to have_title(full_title('О нас'))
    click_link "Контакты"
    expect(page).to have_title(full_title('Контакты'))
    click_link "Главная"
    page.first(:link, "Регистрация").click
    expect(page).to have_title( full_title('Регистрация'))
    click_link "Обеденный советник"
    expect(page).to have_title( full_title(''))
  end
end
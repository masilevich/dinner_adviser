require 'spec_helper'

describe "Static pages" do

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
      it { should have_link("Зарегистрироваться", href: new_user_registration_path) }
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


end
require "spec_helper"
 
module HelperMethods
 
  def logout_user(user = @current_user)
    Capybara.reset_sessions!
    visit destroy_user_session_url
  end
 
  def login_as_capybara(user)
    logout_user if @current_user
    @current_user = user
    visit new_user_session_url
    fill_in :user_login, :with => @current_user.email
    fill_in :user_password, :with => @current_user.password
    click_button "Войти"  
  end
 
end
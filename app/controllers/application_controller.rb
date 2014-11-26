class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.sign_in_count == 1
      introduction_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protect_from_forgery with: :exception

  layout :resolve_layout

  def resolve_layout
    if devise_controller? then
      "devise"
    else
      case controller_name
      when "products", "courses", "advices", "categories"
        case action_name
        when "new" , "edit" , "show"
          "form_for_food_links_menu"
        else 
          "food_links_menu"
        end
      when "menus", "shopping_lists"
        case action_name
        when "show"
          "form_for_food_links_menu"
        else 
          "food_links_menu"
        end
      else
        "application"
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

end

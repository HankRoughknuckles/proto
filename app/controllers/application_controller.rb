class ApplicationController < ActionController::Base
  helper_method :current_user_has_gold_status?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?

  def current_user_has_gold_status?
    current_user && current_user.gold_status == true
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) << :username
      devise_parameter_sanitizer.for(:account_update) << :profile_picture
    end
end

module ApplicationHelper
  def full_title(title)
    return "Proto" if title.blank?
    return "Proto | #{title}"
  end

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def continue_with_facebook_link
    link_to "Continue with Facebook", user_omniauth_authorize_path(:facebook), class: "continue_with_facebook"
  end
end

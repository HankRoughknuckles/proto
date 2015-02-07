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
end

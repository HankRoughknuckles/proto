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
    link_to "Continue with Facebook", user_omniauth_authorize_path(:facebook), class: "continue_with_facebook button"
  end

  def sign_out_button
    link_to "Sign Out", destroy_user_session_path, { method: :delete, 
                                                     class: "sign_out" }
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% facebook_share_url
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def facebook_share_url
    "http://www.facebook.com/sharer/sharer.php?u=#{request.original_url}"
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% twitter_share_url
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def twitter_share_url(idea)
    body = CGI.escape("Check out my business idea on #proto - #{idea.title} - #{request.original_url}")
    return "http://twitter.com/intent/tweet?status=#{body}"
  end
end

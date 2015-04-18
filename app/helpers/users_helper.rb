module UsersHelper
  def activate_gold_status_link_for(user)
    if current_user == user && current_user.has_gold_credit?
      return link_to "Activate Gold Status!", gold_activation_path, 
        { class: "activate_gold_status" }
    end
  end
end

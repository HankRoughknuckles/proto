module UsersHelper
  def activate_gold_status_link(name = "Activate Gold Status", options = {})
    # add activate_gold_status class
    options[:class] = "activate_gold_status " + options[:class].to_s

    return link_to name, gold_activation_path, options
  end
end

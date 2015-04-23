module IdeasHelper
  # displays the vote tally for the passed idea
  def vote_tally_for(idea)
    content_tag :span, idea.get_upvotes.size - idea.get_downvotes.size,
      {
        class: "votes votes-#{idea.id}",
        data: {
          dbid: idea.id
        }
      }
  end


  # displays the link for taking the user to the list of email subscribers
  # for the idea
  def list_emails_link_for(idea, options = {})
    path = email_list_idea_path(idea)

    class_attr = "list_emails"
    class_attr += " #{options[:class]}" unless options[:class].nil?
    attrs = { class: class_attr}

    return link_to "You have #{pluralize idea.subscribers.count, "Subscriber"}", path, attrs
  end


  # displays the link for upvoting for the passed idea
  def upvote_link_for(idea, options = {})
    if user_signed_in?
      path = upvote_idea_path(idea)
      return link_to 'Upvote', path, upvote_attrs(idea, options)

    else
      path = new_user_registration_path
      return link_to "Upvote", path, login_link_attrs(idea, :upvote)
    end
  end


  # displays the link for downvoting for the passed idea
  def downvote_link_for(idea, options = {})
    if user_signed_in?
      path = downvote_idea_path(idea)
      return link_to 'Downvote', path, downvote_attrs(idea, options) 

    else
      path = new_user_registration_path
      return link_to "Downvote", path, login_link_attrs(idea, :downvote)
    end
  end


  def subscribe_link_for(idea, options = {})
    class_attr = "subscribe"
    class_attr += " #{options[:class]}" unless options[:class].nil?

    if user_signed_in?
      path = subscribe_idea_path(idea)
      attrs = {
        method: :post,
        # remote: true,
        class: class_attr
      }
    else
      path = new_user_registration_path
      attrs = {
        class: class_attr
      }
    end

    return link_to "Send my email address to the creator", path, attrs
  end


  # returns a hash of html_attrs to be added to an upvote button
  def upvote_attrs(idea, options = {})
    class_attr =    "upvote upvote-#{idea.id}"
    class_attr +=   " #{options[:class]}"   unless options[:class].nil?
    class_attr +=   " selected"             if current_user.upvoted? idea

    return {
      method:       :put, 
      class:        class_attr,
      title:        "Click if you like this idea",
      remote:       true,
      data: {
        dbid: idea.id
      }
    }
  end

      
  # returns a hash of html_attrs to be added to an downvote button
  def downvote_attrs(idea, options = {})
    class_attr =    "downvote downvote-#{idea.id}"
    class_attr +=   " #{options[:class]}"   unless options[:class].nil?
    class_attr +=   " selected"             if current_user.downvoted? idea

    return {
      method:       :put, 
      class:        class_attr,
      title:        "Click if you think this is a bad idea",
      remote:       true,
      data: {
        dbid: idea.id
      }
    }
  end


  def login_link_attrs(idea, votetype)
    if votetype == :upvote
      class_attr = "upvote upvote-#{idea.id}"
    elsif votetype == :downvote
      class_attr = "downvote downvote-#{idea.id}"
    end

    return {
      class: class_attr, 
      title: "You must be logged in to vote"
    }
  end
end

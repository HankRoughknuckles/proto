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


  # displays the link for upvoting for the passed idea
  def upvote_link_for(idea)
    if user_signed_in?
      path = upvote_idea_path(idea)
      return link_to 'Upvote', path, upvote_attrs(idea)

    else
      path = new_user_session_path
      return link_to "Upvote", path, login_link_attrs(:upvote)
    end
  end


  # displays the link for downvoting for the passed idea
  def downvote_link_for(idea)
    if user_signed_in?
      path = downvote_idea_path(idea)
      return link_to 'Downvote', path, downvote_attrs(idea) 

    else
      path = new_user_session_path
      return link_to "Downvote", path, login_link_attrs(:downvote)    
    end
  end


  # returns a hash of html_attrs to be added to an upvote button
  def upvote_attrs(idea)
    class_attr = "upvote upvote-#{idea.id}"
    class_attr = class_attr + " selected" if current_user.upvoted? idea

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
  def downvote_attrs(idea)
    class_attr = "downvote downvote-#{idea.id}"
    class_attr = class_attr + " selected" if current_user.downvoted? idea

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


  def login_link_attrs(votetype)
    if votetype == :upvote
      class_attr = "upvote upvote-#{idea.id}"
    elsif votetype == :downvote
      class_attr = "downvote downvote-#{idea.id}"
    end

    return {
      class: class_attr, 
      title: "You must be logged in to upvote"
    }
  end
end
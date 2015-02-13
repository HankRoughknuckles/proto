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
      return link_to 'Upvote', upvote_idea_path(idea), upvote_attrs(idea)

    else
      return link_to "Upvote", new_user_session_path, {
        class: "upvote upvote-#{idea.id}", 
        title: "You must be logged in to upvote"
      }
    end
  end


  # displays the link for downvoting for the passed idea
  def downvote_link_for(idea)
    if user_signed_in?
      class_attr = "downvote downvote-#{idea.id}"
      vote = current_user.voted_as_when_voted_for idea
      if (vote != nil) && (vote == false)
        class_attr = class_attr + " selected" 
      end

      return link_to 'Downvote', downvote_idea_path(idea), {
        method:       :put, 
        class:        class_attr,
        title:        "Click if you think this is a bad idea",
        remote:       true,
        data: {
          dbid: idea.id
        }
      }
    else
      return link_to "Downvote", new_user_session_path, {
        class: "downvote downvote-#{idea.id}", 
        title: "You must be logged in to downvote"
      }
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
end

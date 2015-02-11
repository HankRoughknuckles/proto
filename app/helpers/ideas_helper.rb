module IdeasHelper
  def upvote_link_for(idea)
    if user_signed_in?
      return link_to 'Upvote', upvote_idea_path(idea), {
        method: :put, 
        class: "upvote upvote-#{idea.id}",
        title: "Click if you like this idea",
        remote: true
      }
    else
      return link_to "Upvote", new_user_session_path, {
        class: "upvote upvote-#{idea.id}", 
        title: "You must be logged in to upvote"
      }
    end
  end

  def downvote_link_for(idea)
    link_to 'Downvote', downvote_idea_path(idea), 
      {
        method: :put, 
        class: "downvote downvote-#{idea.id}",
        title: "Click if you think this is a bad idea",
        remote: true
      }
  end
end

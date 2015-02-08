module IdeasHelper
  def upvote_link_for(idea)
    link_to 'Upvote', upvote_idea_path(idea), 
      {
        method: :put, 
        class: "upvote upvote-#{idea.id}",
        title: "Click if you like this idea"
      }
  end

  def downvote_link_for(idea)
    link_to 'Downvote', downvote_idea_path(idea), 
      {
        method: :put, 
        class: "downvote downvote-#{idea.id}",
        title: "Click if you think this is a bad idea"
      }
  end
end

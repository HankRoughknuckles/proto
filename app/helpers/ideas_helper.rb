module IdeasHelper
  def upvote_link_for(idea)
    link_to 'Upvote', upvote_idea_path(idea), 
      {
        method: :put, 
        class: "upvote upvote-#{idea.id}",
        title: "Click if you like this idea"
      }
  end
end

$ ->
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Submit google analytics event on comment creation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  $("form.new_comment").submit (e) ->
    ideaTitle = $(".idea_title").text()

    if $("#comment_body").val().length > 0 
      ga('send', 'event', 'Comment on Idea', 'Create', ideaTitle)
    else
      alert "Please leave a comment first!"
      return false

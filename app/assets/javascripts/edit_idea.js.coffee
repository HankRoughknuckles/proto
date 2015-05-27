$ ->

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Updating an idea
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  $(".ideas.edit form").submit ->
    title = $("#idea_title").val()

    if title.length > 0 # if title isn't blank
      ga('send', 'event', 'Idea', 'Update', title );


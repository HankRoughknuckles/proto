$ ->

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Submit google analytics event on form submit
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  $(".ideas.new form").submit ->
    title = $("#idea_title").val()
    if title.length > 0 # if title isn't blank
      ga('send', 'event', 'Idea', 'Create', title )

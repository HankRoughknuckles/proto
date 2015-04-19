# Place all the behaviors and hooks related to the matching controller
# here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The upvote button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # if the upvote button doesn't have the selected class, change the vote
  # on screen and add it.  Also remove the selected class from the
  # downvote button
  $("a.upvote").click ->
    ideaId = $(this).attr("data-dbid")

    if not $(this).hasClass("selected")
      _gaq.push(['_trackEvent', 'upvote', 'clicked'])

      if downvoteButtonFor(ideaId).hasClass("selected")
        changeVoteFor ideaId, 2
      else
        changeVoteFor ideaId, 1

      addChosenClassTo $(this)
      downvoteButtonFor(ideaId).removeClass("selected")


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The downvote button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # if the downvote button doesn't have the "selected" class, change the
  # vote on screen and add it.  Also remove the selected class from the
  # upvote button
  $("a.downvote").click ->
    ideaId = $(this).attr("data-dbid")

    if not $(this).hasClass("selected")
      _gaq.push(['_trackEvent', 'downvote', 'clicked'])

      if upvoteButtonFor(ideaId).hasClass("selected")
        changeVoteFor ideaId, -2
      else
        changeVoteFor ideaId, -1
      addChosenClassTo $(this)
      upvoteButtonFor(ideaId).removeClass("selected")


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # changeVoteFor()
  # finds the vote tally element in the DOM that has the passed dbid and
  # increments it by the amount specified in the passed amount
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  changeVoteFor = (dbid, amount) ->
    $voteCounter =      $(".votes.votes-#{dbid}")
    currentAmount =     parseInt $voteCounter.text()

    $voteCounter.text( currentAmount + amount )


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # addChosenClassTo()
  # adds the "selected" class to the passed DOM element
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  addChosenClassTo = (element) ->
    $(element).addClass("selected")


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # upvoteButtonFor()
  # Returns a reference to the jquery object for the upvote button on the
  # page
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  upvoteButtonFor = ( id ) ->
    return $(".upvote.upvote-#{id}")


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # downvoteButtonFor()
  # Returns a reference to the jquery object for the downvote button on
  # the page
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  downvoteButtonFor = ( id ) ->
    return $(".downvote.downvote-#{id}")

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
# TODO: Use ajax here, and only send it if the element does not have the
# 'seelected' class. Use this when you implement the tests to help them
# pass
  $("a.upvote").click ->
    ideaId = $(this).attr("data-dbid")

    if not $(this).hasClass("selected")
      voteForIdea ideaId, 1
      addChosenClassTo $(this)
      downvoteButtonFor(ideaId).removeClass("selected")


  $("a.downvote").click ->
    ideaId = $(this).attr("data-dbid")

    if not $(this).hasClass("selected")
      voteForIdea ideaId, -1
      addChosenClassTo $(this)
      upvoteButtonFor(ideaId).removeClass("selected")



  # finds the vote tally element in the DOM that has the passed dbid and
  # increments it by the amount specified in the passed amount
  voteForIdea = (dbid, amount) ->
    $voteCounter =      $(".votes.votes-#{dbid}")
    currentAmount =     parseInt $voteCounter.text()

    $voteCounter.text( currentAmount + amount )


  addChosenClassTo = (element) ->
    $(element).addClass("selected")


  upvoteButtonFor = ( id ) ->
    return $(".upvote.upvote-#{id}")


  downvoteButtonFor = ( id ) ->
    return $(".downvote.downvote-#{id}")

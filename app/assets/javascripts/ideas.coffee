# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("a.upvote").click ->
    ideaId = $(this).attr("data-dbid")
    voteForIdea ideaId, 1


  # finds the vote tally element in the DOM that has the passed dbid and
  # increments it by the amount specified in the passed amount
  voteForIdea = (dbid, amount) ->
    $voteCounter =      $(".votes.votes-#{dbid}")
    currentAmount =     parseInt $voteCounter.text()

    $voteCounter.text( currentAmount + amount )

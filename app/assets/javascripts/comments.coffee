# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".submit_comment").click (e) ->
    if $("#comment_body").val().length > 0
      _gaq.push(['_trackEvent', 'comment', 'submitted'])

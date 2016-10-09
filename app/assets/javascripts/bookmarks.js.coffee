# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
   getTitle = (th) ->

       $this = $(th)
       id = $this.attr("id")
       $.get "getTitle", (data) ->
          $("#bookmark_title").attr('value', data);

   $('.getTitle').bind 'click', getTitle

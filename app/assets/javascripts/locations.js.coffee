# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  
   setVisibilityStorageFields = () ->
     lt = $("#location_typ option:selected").prop("value")     
     if lt == "0"  # Generic Web access
       $(".storagefields").css({"display": "none"})
     else 
       $(".storagefields").css({"display": "block"})
       
   setVisibilityStorageFields()
   
   $("#location_typ").change ->
     lt = $("#location_typ option:selected").prop("value")     
     if lt == "0"  # Generic Web access
       $(".storagefields").css({"display": "none"})
     else 
       $(".storagefields").css({"display": "block"})
      
   checkAvailiblity = (th) ->

       $this = $(th)
       id = $this.attr("id")

       $.get "requestTitle", (data) ->
          $("#titlee").html(data)
#      $("#titlee").html(id)
   
   checkAvailiblity()
   $('.checkAvailiblity').bind 'click', checkAvailiblity

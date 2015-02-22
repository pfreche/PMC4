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
       $.get "checkAvail", (data) ->
          $("#aval").html(data)
 #      
   checkAvailiblity()
            
   getTitle = (th) ->

       $this = $(th)
       id = $this.attr("id")
       $.get "getTitle", (data) ->
          $("#location_name").attr('value', data);
        

   $('.getTitle').bind 'click', getTitle

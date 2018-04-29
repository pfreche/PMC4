
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

  clickTimeout = false
  clickTimeout2 = false
  actualPic = false
  a = 0
  name  = ""

  hlColour = "#ddf"

  if window.location.pathname == "/mfiles/thumbs"
     key1 =  true

  $(document).keydown (e) ->
    if key1 == true
#      alert(e.keyCode)
      if e.which == 68
        id = actualPic.attr("id")
        $.get id+"/download", (data) ->
          alert(id+" "+data)
      if e.which == 37
         prevPic(actualPic)
      if e.which == 39
         nextPic(actualPic)
      if e.which == 89
        id = actualPic.attr("id")
        $.get id+"/youtubeLink", (data) ->
#          window.location = data
          window.open(data, 'you')
#          $("#bildCont").html("")
#          $("#overlayPic").hide()
          $("video")[0].pause()
     true

  $('#name').autocomplete
    source: $('#name').data('autocomplete-source')
#  source: ['fee', 'bla','oeter']
    select: (a,b) ->
       setTimeout () ->
         hhi =   $('#name').val()
         $("#but").text(hhi)
         $("#setIt").text(hhi)
         $("#namei").attr("value", hhi)
       ,10
       $("#ag_id").attr('value','-1')
       $("#AorG").attr('value','a')

  selectMfileP = () ->
    $this = $(this)
    if clickTimeout2
      clearTimeout(clickTimeout2)
      $inp = $this.find("input")
      if $inp.attr('value') == "1"
        $inp.attr('value', "0");
        $this.css "background-color", ""
        $this.css "border-color", ""
        $this.css({ 'opacity' : ""})
      else
        $inp.attr('value', "1");
        $this.css "background-color", hlColour
        $this.css "border-color", hlColour
        $this.css({ 'opacity' : 1.00})
    else
      showPic($this)



  selectMfileDisabled = () ->
    $this = $(this)
    $inp = $this.find("input")
    if $inp.attr('value') == "1"
      $inp.attr('value', "0");
      $this.css "background-color", "white"
    else
      $inp.attr('value', "1");
      $this.css "background-color", hlColour
    end

  selectAll = () ->
    aa = "input"
#   $(aa).attr('value', "1");

    $(".thumbC.vis .check input").attr('value', "1")

    $(".thumbC.vis").css {"background-color": hlColour}
    $(".thumbC.vis").css "border-color", hlColour
    $(".thumbC.vis").css({ 'opacity' : 1.0 })


  hideUnselected = ->

    $(".thumbC").each  (i,e)  ->
      $e = $(e)
      $inp =  $e.find( " input")
      if $inp.attr('value') == "1"
      else
        $inp.attr('value', "-1");
        $e.css({"display": "none"})
        $e.removeClass('vis')

   showAll =  () ->
     $(".thumbC").each  (i,e)  ->
       $e = $(e)
       $e.addClass('vis')
       $e.css({"display": "block"})
       $inp =  $e.find( " input")
       if $inp.attr('value') == "-1"
         $inp.attr('value', "0");


  selectInvert = () ->
    $(".thumbC.vis").each  (i,e)  ->
      $e = $(e)
      $inp =  $e.find( " input")
      if $inp.attr('value') == "1"
        $inp.attr('value', "0");
        $e.css "border-color", ""
        $e.css({ 'opacity' : ""})
      else if $inp.attr('value') == "0"  ## and leave the -1 untouched
          $inp.attr('value', "1");
          $e.css "border-color", hlColour
          $e.css({ 'opacity' : 1.00})

    $("tr").each  (i,e)  ->
      $e = $(e)
      $inp =  $e.find( " input")
      if $inp.attr('value') == "1"
        $inp.attr('value', "0");
        $e.css "background-color", "white"
      else
        $inp.attr('value', "1");
        $e.css "background-color", "green"

  selectByAttribute = () ->

    $this = $(this)
    $this.css('background-color', "")
    clearTimeout(clickTimeout)
    clname = $this.attr("class")
    id = $this.attr("id")
    name = $this.text()
 #  aa = "."+ name
    if clname.indexOf("attribute") > -1
      aa = ".vis.A-"+id
    else
      aa = ".vis.G-"+id

    if clickTimeout
      $("tr").css "background-color", "white"
      $(".thumbC.vis").css "background-color", ""
      $(".thumbC.vis").css "border-color", ""
      $(".thumbC.vis").css({ 'opacity' : "" })
      $(".thumbC.vis .check input").attr('value', "0")

      $(aa).css {"background-color": hlColour}
      $(aa).css "border-color", hlColour
      $(aa).css({ 'opacity' : 1.0 })
 #     $(aa).addClass('SEL')
      aa = aa+" .check input"
      $(aa).attr('value', "1");

    $("#but").html(name)
    $('#setIt').html(name)
    $("#ag_id").attr('value',id)
    $("#AorG").attr('value',clname[1])

  startTimer = () ->
    a = 1
    $th = $(this)
    clickTimeout = setTimeout () ->
      clickTimeout = false;
      $th.css('background-color', "red")
    ,300

  startTimer2 = () ->
    th =$(this)
    clickTimeout2 = setTimeout () ->
      clickTimeout2 = false
      showPic(th)
    ,300

  showPic= (th) ->
#    $this = $(this)
    th = $(this).parent()  # new 1.1.2015
    actualPic = th
    id = th.attr("id")
#    $.get id+"/renderMfile", (data) ->
#      $("#bild").attr('src',data)
    $.get id+"/renderMfile", (data) ->
       $("#bildCont").html(data)
    $("#overlayPic").show()
    $("#dunkel").css('z-index', 2)

    showPicAttris(th)

  showPic2 = (th) ->
    th = $(this)
    actualPic = th
    id = th.attr("id")
    $.get id+"/renderMfile", (data) ->
       $("#bildCont").html(data)
    $("#overlayPic").show()
    $("#dunkel").css('z-index', 2)

    showPicAttris(th)


  nextPic = (th) ->
    ne = actualPic.next()
    if ne.length > 0 # idea!!!!
      actualPic = ne
#       actualPic = erstes Bild
    id = actualPic.attr("id")
    $.get id+"/renderMfile", (data) ->
       $("#bildCont").html(data)

   prevPic = (th) ->
    ne = actualPic.prev()
    if ne.length > 0 
      actualPic = ne
#       actualPic = erstes Bild
    id = actualPic.attr("id")
    $.get id+"/renderMfile", (data) ->
       $("#bildCont").html(data)




  nextPicSlide = (th) ->
    if actualPic == false
       actualPic = $(".vis").first()
    actualPic = actualPic.next()
    if actualPic == false # idea!!!!
      actualPic = actualPic
#       actualPic = erstes Bild
    id = actualPic.attr("id")
    $.get id+"/path", (data) ->
       $("#overlayPicFull").css('background-image', 'url(\''+data+'\')')


   showPicAttris = (th) ->
      attris = th.attr("class").replace(/\s+/g, ' ').split(' ')
      a = ""
      for atr in attris
         if atr.indexOf("G-")!=-1
           x = "#"+atr.substr(2,5).trim()+".agroup_no"
           b = $(x).html()
           a = a + "<div class='agroupRight'>"+ " "+ b + " </div>"

         if atr.indexOf("A-")==-1
#          a = a + "<div class='attributeRight'> notfound"+ atr + "</div>"
         else
           x = "#"+atr.substr(2,5).trim()+".attribute"
           b = $(x).html()
           a = a + "<div class='attributeRight'>"+  " "+ b + " </div>"

      $("#bildAttris").html(a)

  thumbSize = (th) ->
        $this = $(this)
        size = $this.val()
        $(".thumbC.vis").css({ 'width' : size })
        $(".thumbC.vis").css({ 'height' : size })




  $("#bildCont").bind 'click', ->
    $("#bildCont").html("")
    $("#overlayPic").hide()
#    $("video")[0].pause()
    $("#dunkel").css('z-index', -2)

  $("#bildNext").bind 'click', ->
    nextPic()
    showPicAttris(actualPic)

  $("#bildPrev").bind 'click', ->
    prevPic()
    showPicAttris(actualPic)

#  $("#bildNextSlide").bind 'click', ->
#    nextPicSlide()


  $('#selAll').bind 'click', selectAll
  $('#selectInvert').bind 'click', selectInvert
  $('.selAtgr').mousedown(startTimer).click(selectByAttribute)
#  $('.balken').mousedown(startTimer).click(selectByAttribute)
#  $('.mfileTable tr').bind 'click', selectMfile

#  $('.thumbC').bind 'click', showPic
#  $('.thumbC').bind 'click', selectMfileP
  $('.thumbC').mousedown(startTimer2).click(selectMfileP)
#
  $('.thumbe').bind 'click', showPic2
  $('.marker').click(showPic)

  $('#hideUnselected').bind 'click', hideUnselected
  $('#showAll').bind 'click', showAll

  $('#setIt').click ->
    $('#but').trigger('click')

  $('#selectAll').bind 'click', selectAll
  $('#overlayPic').hide()

  selectAll()
  $('#thumbSize').bind 'change', thumbSize
#    $(aa).each (i,e) ->
#      $(e).attr('value', "1");


 #   $("input").attr('checked', true)
 #   $("input").removeAttr('checked')
 #   $(':checkbox').attr('checked', false);

  # setClass = () ->
#
    # $inp = $("tbody tr")
    # name = $("#but").html("adaadfaf")
#
    # $inp.each (elem) ->
      # $in = $(elem).find(".check input")
      # if $in.attr('value') == "1"
        # $in.removeClass(name)
      # else
        # $in.addClass(name)

#  $('.selAtgr').bind 'dblclick', selectByAttribute

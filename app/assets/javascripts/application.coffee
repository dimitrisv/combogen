#= require jquery
#= require jquery_ujs
#= require jquery_nested_form
#= require jquery-ui.min
#= require twitter/bootstrap
#
#= require underscore
#= require backbone
#
#= require selectize/selectize
#= require selectize/plugins/drag_drop/plugin
#= require selectize/plugins/remove_button/plugin
#= require selectize/plugins/restore_on_backspace/plugin
#
#= require backbone/app
#= require_tree ./backbone/views/

$(document).ready ->

  LevelApp.initialize()
  
  # Collapsing menu for mobile
  $("#toggle-collapse").click (e) ->
    $("#nav").toggle()
    # $("#nav-collapse a").toggleClass("active");
    e.preventDefault()

  # make all elements with the .btn act as buttons
  $(".btn").button()
  
  # BOOTSTRAP 3.0 - Open YouTube Video Dynamicaly in Modal Window
  # Modal Window for dynamically opening videos
  # http://www.joshuawinn.com/opening-youtube-links-dynamically-in-a-twitter-bootstrap-modal-window/
  $("a[data-video-id]").on "click", (e) ->
    # do not open modal until iframe is injected
    e.preventDefault()
    
    # retrieve relevant data attributes
    targetElement = $(this).attr("data-target")
    videoId = $(this).attr("data-video-id")
    
    # check if they are legit
    iFrameCode = "<h3>The data-video-id attribute was not specified.</h3>"  unless videoId
    
    # Variables for iFrame code. Width and height from data attributes, else use default.
    vidWidth = 100 # default (in %)
    vidHeight = 315 # default (in px)
    startTime = "&start=" + $(this).attr("data-start-time")
    endTime = "&end=" + $(this).attr("data-end-time")
    
    # create iframe code
    iFrameCode = "<iframe width=\"" + vidWidth + "%\" height=\"" + vidHeight + "\" scrolling=\"no\" allowtransparency=\"true\" allowfullscreen=\"true\" src=\"http://www.youtube.com/embed/" + videoId + "?autoplay=1&rel=0&wmode=transparent&showinfo=0" + startTime + endTime + "\" frameborder=\"0\"></iframe>"
    
    # Replace modal's HTML with iFrame embed and open it
    $(targetElement + " .modal-body .video-container").html iFrameCode
    $(targetElement).modal()

  # When modal closes, stop video playback.
  # Clear the 'src' attribute of the iframe so the video is forced to reload
  $("#watch-tutorial-modal").on "hidden.bs.modal", (e) ->
    $("#watch-tutorial-modal iframe").attr "src", ""

  $("#watch-combo-modal").on "hidden.bs.modal", (e) ->
    $("#watch-combo-modal iframe").attr "src", ""

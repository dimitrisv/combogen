// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery_nested_form
//= require twitter/bootstrap

$(document).ready(function(){  
  
  // Collapsing menu for mobile
  $("#toggle-collapse").click(function(e){
    $("#nav").toggle();
    // $("#nav-collapse a").toggleClass("active");
    e.preventDefault();
  });

  // make all elements with the .btn act as buttons
  $(".btn").button();

  // BOOTSTRAP 3.0 - Open YouTube Video Dynamicaly in Modal Window
  // Modal Window for dynamically opening videos
  // http://www.joshuawinn.com/opening-youtube-links-dynamically-in-a-twitter-bootstrap-modal-window/
  $('a[data-video-id]').on('click', function(e){
    // do not open modal until iframe is injected
    e.preventDefault();

    // retrieve relevant data attributes
    var targetElement = $(this).attr('data-target');
    var videoId = $(this).attr('data-video-id');

    // check if they are legit
    if ( !videoId ) {
      var iFrameCode = "<h3>The data-video-id attribute was not specified.</h3>";
    }

    // Variables for iFrame code. Width and height from data attributes, else use default.
    var vidWidth = 100; // default (in %)
    var vidHeight = 315; // default (in px)

    var startTime = "&start="+$(this).attr('data-start-time')
    var endTime = "&end="+$(this).attr('data-end-time')

    // create iframe code
    var iFrameCode = '<iframe width="' + vidWidth + '%" height="'+ vidHeight +'" scrolling="no" allowtransparency="true" allowfullscreen="true" src="http://www.youtube.com/embed/'+ videoId +'?autoplay=1&rel=0&wmode=transparent&showinfo=0'+ startTime + endTime +'" frameborder="0"></iframe>';

    // Replace modal's HTML with iFrame embed and open it
    $(targetElement+' .modal-body .video-container').html(iFrameCode);
    $(targetElement).modal();
  });

  // When modal closes, stop video playback.
  // Clear the 'src' attribute of the iframe so the video is forced to reload
  $('#watch-tutorial-modal').on('hidden.bs.modal', function (e) {
    $("#watch-tutorial-modal iframe").attr("src", "");
  });
  $('#watch-combo-modal').on('hidden.bs.modal', function (e) {
    $("#watch-combo-modal iframe").attr("src", "");
  });

});
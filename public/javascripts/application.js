// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $('#user_bar').load('/account/status');
  
  var normal_text = $('.rating_text').html();
  var current_stars_class = $('.stars').attr('class');
  var score;
  $('.stars.not_voted').mousemove(function(e){
    var pos = e.clientX - $(this).offset().left
    $('.rating_text').html(pos)
    if(pos > 114){
      score = 50;
    } else if (pos > 101) {
      score = 45;
    } else if (pos > 88) {
      score = 40;
    } else if (pos > 76) {
      score = 35;
    } else if (pos > 63) {
      score = 30;
    } else if (pos > 51) {
      score = 25;
    } else if (pos > 38) {
      score = 20;
    } else if (pos > 25) {
      score = 15;
    } else if (pos > 13) {
      score = 10;
    } else if (pos > 3) {
      score = 5
    } else {
      score = 0
    }
    $(this).attr('class', 'stars not_voted stars-' + score);
    $('.rating_text').html("Vote " + (score / 10.0) + " stars for this location");
  }).mouseout(function(){
    $(this).attr('class', current_stars_class);
    $('.rating_text').html(normal_text);
  }).click(function(){
    $('.center.rating').hide().after('<div class="center" id="loader"><img src="/images/loader-blue.gif" width="54" height="55" /></div>');
    $.post($('.center.rating').attr('rel'), {authenticity_token: _token, score: score}, null, "script");
  });
})
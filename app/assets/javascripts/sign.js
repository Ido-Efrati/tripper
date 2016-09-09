// @author: Jesika Haria

$(document).ready(function(){
  $('#signup-ask').click(function() {
    $('#signin-form').hide();
    $('#signup-form').show();
  });

  $('.signup-back').click(function() { 
    window.location = "/";
    $('#signup-form').hide(); 
    $('#signin-form').show(); 
  });
}); 
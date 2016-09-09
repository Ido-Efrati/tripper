// @author Ryan Lacey

$(function() {

  $(document).on('click', '#addTripper', attachAddTripperHandler);

  if ($.fn.accordion) {
    $("#accordion").accordion({
    	active: false,
    	collapsible: true,
		heightStyle: "content"
    });
  }
});

var counter = 1;
var attachAddTripperHandler = function() {
  $("<div class=\"field\"><label for=\"trip_tripper" + counter + "\">Tripper " + counter + "</label><br><input id=\"tripper" + counter + "\" class=\"tripperEmail\" name=\"trippers[tripper" + counter + "]\" type=\"text\"></div>").insertBefore("#addTripper");
  counter += 1;
  $(".tripperEmail").on('keyup change', function() {
    var field = $(this);
    var email = field.val();
    $.ajax({
      type: "GET",
      url: "/users/exists",
      dataType: "JSON",
      data: { 'email': email },
      success: function(data) {
        if (data) {
          field.removeClass("errorField");
          field.addClass("successField");
        } else {
          field.removeClass("successField");
          field.addClass("errorField");
        }
      }
    });
  });
};

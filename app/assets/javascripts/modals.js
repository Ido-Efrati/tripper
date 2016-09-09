// @author Jesika Haria

$(document).ready(function(){

// CSRF security tokens 
$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

// Enabling autofocus on forms 
$(".modal").on('shown', function() {
    $(this).find("[autofocus]:first").focus();
});

// Create new exchange 
  $('#save-changes').click(function(e) {  
    e.preventDefault(); 
    
    var rate = $('#rate').val(); 
    var units = $('#units').val(); 
    var url = window.location.pathname; 
    var trip_id = url.substring(url.lastIndexOf('/') + 1);

    $.ajax({
            type: "POST",
            contentType: 'application/json',
            url: '/exchanges/',
            data: JSON.stringify({'rate': rate, 'units': units, 'trip_id': trip_id}),
            dataType: "json",
            success: function(data){
              location.reload(); 
            }, 
            error: function(data) {
              console.log(data); 
              err_msg = "<strong>Please correct the following errors</strong><br><br>"; 
              var err = JSON.parse(data.responseText); 
              err_msg = err_msg + "units: " + err['units'] + "<br>rate: " + err['rate']; 
              //alert(err_msg);
              $('#modal-header').css({'color': '#F95A61'});
              $('#modal-header').html(err_msg); 
            }
        });
    return false; 
  });

// Create new cost
  $('#new_cost').submit(function(e) {  
    e.preventDefault(); 

    var value = $('#value').val(); 
    var description = $('#description').val(); 
    var exchange_id = $('select').val(); 

    var url = window.location.pathname; 
    var trip_id = url.substring(url.lastIndexOf('/') + 1);
        console.log(location); 

    $.ajax({
            type: "POST",
            contentType: 'application/json',
            url: '/trips/' + trip_id + '/costs/',
            data: JSON.stringify({'value': value, 'description': description, 'exchange_id': exchange_id, 'trip_id': trip_id}),
            dataType: "json",
            success: function(data){
              location.reload(); 
            }, 
            error: function(xhr, status, error) {
              if (error == 'Unprocessable Entity') {
              var err_msg =  "<strong>Please correct the following errors</strong><br><br>"; 
              var err = JSON.parse(xhr.responseText);
              err_msg = err_msg + "value: " + err['value']
              } else {
                var err_msg = "Oops something went wrong."; 
              }
              $('#costModal-header').css({'color': '#F95A61'});
              $('#costModal-header').html(err_msg); 
            }
        });
 
    return false; 
  });


});


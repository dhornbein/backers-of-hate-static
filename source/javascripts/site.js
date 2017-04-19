//= require jquery
//= require tether
//= require bootstrap-sprockets

$(document).ready(function() {
  var formID        = "#embedForm",
      newFormID     = "#new_delivery",
      letterFormID  = "#letter-form";

    $(document).on('can_embed_loaded', function(e) {
        // do your work here, after the widget is loaded
        var submitText = $(formID).data('submit');
        var submitBtn = $(e.target).find(letterFormID + " input[type='submit']");

        submitBtn.each( function(i,e){
          if (typeof submitText !== undefined) {
            $(e).attr("data-original",$(e).val());
            $(e).val(submitText);
          }
        });
    });
});

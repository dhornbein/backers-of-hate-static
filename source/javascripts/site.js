//= require jquery
//= require tether
//= require bootstrap-sprockets

$(document).ready(function() {
  var embedId       = "#embedForm",
      targetForm    = "#new_signature";

    $(document).on('can_embed_loaded', function(e) {
        // do your work here, after the widget is loaded
        var submitText = $(embedId).data('submit');
        var submitBtn = $(e.target).find(targetForm + " input[type='submit']");

        $(embedId + " #form-comments").attr({
          "placeholder" : "Write your letter *",
          "required" : true
        });
        submitBtn.each( function(i,e){
          if (typeof submitText !== undefined) {
            $(e).attr("data-original",$(e).val());
            $(e).val(submitText);
          }
        });
    });
});

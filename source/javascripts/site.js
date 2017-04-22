//= require jquery
//= require tether
//= require bootstrap-sprockets

$(document).ready(function() {
  var embedId       = "#embedForm",
      targetForm    = "#new_signature",
      shareId       = "#share-block",
      nextId        = "#next-block";

    $(document).on('can_embed_loaded', function(e) {
      var submitBtn = $(e.target).find(targetForm + " input[type='submit']");
      // Text for substitution is pulled from data-attributes
      var submitText  = $(embedId).data('submit');
      var commentText = $(embedId).data('comment');
      var commentAttr = {
                          "placeholder" : commentText + " *",
                          "required" : true,
                          "cols" : "",
                          "rows" : ""
                        };
      // replaces comment textarea with commentAttr
      $(embedId + " #form-comments").attr(commentAttr);

      // replaces each submit input
      submitBtn.each( function(i,e){
        if (typeof submitText !== undefined) {
          $(e).attr("data-original",$(e).val());
          $(e).val(submitText);
        }
      });

      // if we find #action_welcome_message add a class
      // this class tells our CSS to NOT split into columns
      if (document.getElementById('action_welcome_message')) {
        $(targetForm).addClass("can_returning");
      } else {
        $(targetForm).removeClass("can_returning");
      }
    });
    // Fires on successful submission
    $(document).on('can_embed_submitted', function(e) {
      // grabs HTML of targets and places them into the thank you message
      // changes their ID's to id-name-placed
      $(nextId).clone().prop("id",nextId.substr(1) + "-placed").insertAfter("#can_thank_you > h1");
      $(shareId).clone().prop("id",shareId.substr(1) + "-placed").insertAfter("#can_thank_you > h1");
    });

    // any link to #email will expand #email and scroll there
    $("a[href='#email']").click( function(e){
      e.preventDefault();
      sendToEmail()
    });

    function sendToEmail(){
      $("#email").collapse('show');
      $('html, body').animate({
        scrollTop: $("#email").offset().top
      }, 500);
    }
});

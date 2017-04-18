//= require jquery
//= require tether
//= require bootstrap-sprockets

$(document).ready(function() {
    $(document).on('can_embed_loaded', function(e) {
        // do your work here, after the widget is loaded
        console.log(e);
    });
});

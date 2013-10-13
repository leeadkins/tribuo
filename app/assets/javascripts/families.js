// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Pretty basic, hacky stuff.

$(function() {
  $('#add_child_button').click(function() {

    var $tmpl = $("#new_child_attributes");

    $('.child_fields').append($tmpl.html());

  });
});
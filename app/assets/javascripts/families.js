// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Pretty basic, hacky stuff.

$(function() {
  var source = $("#new_child_attributes").html();
  var $template = Handlebars.compile(source);

  // Generates new form fields for nested attributes

  // Notes on field name generation: 
  // When dealing with collections of child attributes in nested form 
  // situations, rails expects hashes instead of arrays. It uses the ID of
  // the child as the key to the hash object like so
  /// family[children_attributes][3][gender]

  // For new records, you can just pretend it's an array with no key. Because you 
  // don't have an ID yet, like this:
  // family[children_attributes][][gender]
  
  // But for editing a family, where you'll have a mix of new and old ones, that
  // doens't work, because you're mixing Arrays and Hashes. So, we'll just generate
  // a semi-random/unique-for-this-pageview id to use. It doesn't matter what it is
  // actually. So we'll just use the current timestamp. This isn't fool-proof, and
  // could technically collide with real ints in a huge system, but it's not likely,
  // and is fine for this use.

  $('#add_child_button').click(function() {

    $('.child_fields').append($template({index: new Date().getTime()}));

  });
});
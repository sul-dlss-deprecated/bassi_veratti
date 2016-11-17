//= require blacklight/core
(function($) {
  /* Forward port from Blacklight 4.7.0:
  https://github.com/projectblacklight/blacklight/blob/v4.7.0/app/assets/javascripts/blacklight/facet_expand_contract.js

     Behavior that makes facet limit headings in sidebar expand/contract
     their contents. This is kind of fragile code targeted specifically
     at how we currently render facet HTML, which is why I put it in a function
     on Blacklight instead of in a jquery plugin. Perhaps in the future this
     could/should be expanded to a general purpose jquery plugin -- or
     we should just use one of the existing ones for expand/contract? */
  Blacklight.facet_expand_contract = function() {
   $(this).next("ul, div").each(function(){
     var f_content = $(this);
     $(f_content).prev('h5').addClass('twiddle');
     // find all f_content's that don't have any span descendants with a class of "selected"
     if($('span.selected', f_content).length == 0){
       f_content.hide();
     } else {
       $(this).prev('h5').addClass('twiddle-open');
     }

     // attach the toggle behavior to the h5 tag
     $('h5', f_content.parent()).click(function(){
       $(this).toggleClass('twiddle-open');
       $(f_content).slideToggle();
     });
   });
  };

  Blacklight.onLoad(function() {
    $('#facets h5').each(Blacklight.facet_expand_contract);
  });
})(jQuery);

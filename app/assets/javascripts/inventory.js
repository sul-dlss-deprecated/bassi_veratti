$(document).ready(function(){
  if($("[data-collapse='true']").length > 0) {
    $("ul", $("[data-collapse='true']")).each(function(){
      $(this).children("li[data-behavior='toggle-handler']").each(function(){
        var icon = $(this).children("i");
        icon.toggle();
        var nested_list = $(this).next("li");
        nested_list.hide();
        $("a, i", $(this)).click(function(){
          icon.toggleClass("glyphicon-minus-sign");
          nested_list.slideToggle();
          expandedType = nested_list.children().attr('class');
          if (expandedType == 'folder-items' && icon.is('.glyphicon-minus-sign')) {
            loadInventoryImages(nested_list.find('.item-image-link'));
          }
          $('.scrollspy-content').scrollspy("refresh"); // Refresh the scrollspy since we've changed the DOM
        });
      });
    });
    $('.scrollspy-content').scrollspy("refresh"); // Refresh the scrollspy since we've changed the DOM
  }

  // When we have an anchor on the inventory page on page load
  if($(".blacklight-inventory").length > 0 && window.location.hash != '') {
    var focus = $("[data-reference-id='" + window.location.hash +"']");
    // Show the next list item and all its hidden list item parents
    nested_list = focus.next("li").show();
    loadInventoryImages(nested_list.find('.item-image-link'));
    focus.children("i").toggleClass("glyphicon-minus-sign");
    focus.parents("li:hidden").each(function(){
      $(this).show().prev("li").children("i").toggleClass("glyphicon-minus-sign");
    });
    if (focus.offset()) {
      $(window).scrollTop(focus.offset().top); // Scroll to the item that we're trying to focus on.
    }
    $('.scrollspy-content').scrollspy("refresh"); // Refresh the scrollspy since we've changed the DOM
  }
});

// load all images on the inventory page; not currently used
function loadAllInventoryImages() {
  loadInventoryImages($('.item-image-link'));
}

// only load specified images on the inventory page by passing in a JQuery object (dom item)
function loadInventoryImages(itemImages) {
  for (var i = 0 ; i < itemImages.length; i++) {
    itemImages[i].innerHTML = '<a href="' + itemImages[i].attributes['data-image-link'].value + '"><img alt=\'' + itemImages[i].attributes['data-image-title'].value + '\' title=\'' +  itemImages[i].attributes['data-image-title'].value + '\' src="' + itemImages[i].attributes['data-image-url'].value + '"></a>'
  }
}

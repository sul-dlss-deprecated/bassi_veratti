$(document).ready(function(){

	if($("[data-collapse='true']").length > 0) {
		$("ul", $("[data-collapse='true']")).each(function(){
			var toggle_text = $(this).children("li[data-behavior='toggle-handler']");
			toggle_text.each(function(){
				var icon = $(this).children("i");
				icon.toggle();
			  var nested_list = $(this).next("li");	
  			nested_list.hide();
				$("a, i", $(this)).click(function(){
					icon.toggleClass("icon-minus-sign");
					nested_list.slideToggle();
					expandedType=nested_list.children().attr('class');
					if (expandedType == 'folder-items' && icon.is('.icon-minus-sign')) {
						imageItems=nested_list.find('.item-image-link');
						loadInventoryImages(imageItems);
 					}
					// Refresh the scrollspy since we've changed the DOM
					$('.scrollspy-content').scrollspy("refresh");
				});
			});
		});
		// Refresh the scrollspy since we've changed the DOM
		$('.scrollspy-content').scrollspy("refresh");
	}
	
	// When we have an anchor on the inventory page on page load
  if($(".blacklight-inventory").length > 0 && window.location.hash != '') {
	  var focus = $("[data-reference-id='" + window.location.hash +"']");
	  // Show the next list item and all its hidden list item parents
	  focus.next("li").show();
	  focus.children("i").toggleClass("icon-minus-sign");
	  focus.parents("li:hidden").each(function(){
		  $(this).show();
  		$(this).prev("li").children("i").toggleClass("icon-minus-sign");
	  });
	  // Scroll to the item that we're trying to focus on.
		$(window).scrollTop(focus.offset().top);
		// Refresh the scrollspy since we've changed the DOM
		$('.scrollspy-content').scrollspy("refresh");
  }
});

function loadAllInventoryImages() {
	// load all images on the inventory page; not currently used
	itemImages=$('.item-image-link');
	loadInventoryImages(itemImages);
}

function loadInventoryImages(itemImages) {

	// only load specified images on the inventory page by passing in a dom item
	for (var i = 0 ; i < itemImages.length; i++) {
		itemImages[i].innerHTML='<a href="' + itemImages[i].attributes['data-image-link'].value + '"><img alt=\'' + itemImages[i].attributes['data-image-title'].value + '\' title=\'' +  itemImages[i].attributes['data-image-title'].value + '\' src="' + itemImages[i].attributes['data-image-url'].value + '"></a>'
	}
		
}
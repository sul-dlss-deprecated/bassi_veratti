$(document).ready(function(){

	// load any images on the content inventory page
	itemImages=$('.item-image-link');
	for (var i = 0 ; i < itemImages.length; i++) {
		itemImages[i].innerHTML='<a href="' + itemImages[i].attributes['data-image-link'].value + '"><img alt=\'' + itemImages[i].attributes['data-image-title'].value + '\' title=\'' +  itemImages[i].attributes['data-image-title'].value + '\' src="' + itemImages[i].attributes['data-image-url'].value + '"></a>'
	}
	
	// Modal behavior for collection member show page.
	$("[data-modal-selector]").on('click', function(){
		$($(this).attr("data-modal-selector")).modal('show');
	  return false;
	});

  $('.scrollspy-content').scrollspy({offset: 30});

  $('.overview .nav-pills a:first').tab('show');

	// elements defined with these classes can be hidden by default and then show when the page loads
	//  useful when you have non javascript friendly DOM elements you need to hide for no JS browsers so you can include a <noscript> tag with
	//   non JS versions
	$(".showOnLoad").show();

  // Responsive width when using the bootstrap affix plugin (which makes width absolute)
  $(function(){
    var sideBarNavWidth=$('#sidebar-nav').width() - parseInt($('.nav-list').css('paddingLeft')) - parseInt($('.nav-list').css('paddingRight'));
    $('.nav-list li').css('width', sideBarNavWidth);
  });

});

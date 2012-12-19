$(document).ready(function(){

	// Carousel on show page	
	$("#image_carousel").carousel({
		interval: false
	})
	
	$("#image_carousel").bind('slid', function(){
	  var carousel = $(this);
	  var index = $('.active', carousel).index('#' + carousel.attr("id") + ' .item');
	  $("#iterator", carousel).text(parseInt(index) + 1);
	});
	
	
	// Modal behavior for collection member show page.
	$("[data-modal-selector]").on('click', function(){
		$($(this).attr("data-modal-selector")).modal('show');
	  return false;
	});

  $('.scrollspy-content').scrollspy({offset: 30});
});

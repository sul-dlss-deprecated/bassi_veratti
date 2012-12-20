$(document).ready(function(){
	if($("[data-collapse='true']").length > 0) {
		$("ul", $("[data-collapse='true']")).each(function(){
			var toggle_text = $(this).children("li[data-behavior='toggle-handler']");
			toggle_text.each(function(){
				var icon = $(this).children("i");
				icon.toggle();
			  var nested_list = $(this).next("li");	
  			nested_list.hide();
				$(this).click(function(){
					icon.toggleClass("icon-minus-sign");
					nested_list.slideToggle();
				});
			});
		});
		// Refresh the scrollspy since we've changed the DOM
		$('.scrollspy-content').scrollspy("refresh");
	}
});
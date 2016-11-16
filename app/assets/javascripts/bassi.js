$(document).ready(function(){
  // Modal behavior for collection member show page.
  $("[data-modal-selector]").on('click', function(){
    $($(this).attr("data-modal-selector")).modal('show');
    return false;
  });

  $('.scrollspy-content').scrollspy({offset: 30});

  $('.overview .nav-pills a:first').tab('show');

  // Elements defined with these classes can be hidden by default and then show when the page loads:
  // Useful when you have non-js-friendly DOM elements you need to hide for no-JS browsers
  // so you can include a <noscript> tag with non-JS versions.
  $(".showOnLoad").show();
  $('.showOnLoad').removeClass('hidden');

  // Responsive width when using the bootstrap affix plugin (which makes width absolute)
  $(function(){
    var sideBarNavWidth = $('#sidebar-nav').width() - parseInt($('.nav-list').css('paddingLeft')) - parseInt($('.nav-list').css('paddingRight'));
    $('.nav-list li').css('width', sideBarNavWidth);
  });
});

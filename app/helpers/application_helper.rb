module ApplicationHelper
  
  def on_scrollspy_page?
    on_background_page || on_inventory_pages
  end

  def show_list(mvf)
    mvf.join(', ')
  end
  
end

module ApplicationHelper

  def on_home_page
    request.path == '/' && params[:f].blank?
  end

  def request_path
    Rails.application.routes.recognize_path(request.path)
  end
  
  def on_collections_pages
    request_path[:controller] == 'catalog' && !on_home_page
  end

  def on_background_page
    request_path[:controller] == 'about' && request_path[:action] == 'background'
  end
  
  def on_about_pages
    request_path[:controller] == 'about' && !on_background_page
  end

  def on_inventory_pages
    request_path[:controller] == 'inventory'
  end
  
end

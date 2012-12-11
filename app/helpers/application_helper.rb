module ApplicationHelper
  
  def on_scrollspy_page?
    (request_path[:controller] == 'about' && request_path[:action] == 'background') ||
      request_path[:controller] == 'inventory'
  end

end

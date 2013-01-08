module ApplicationHelper
  
  def on_scrollspy_page?
    on_background_page || on_inventory_pages
  end

  def show_list(mvf)
    mvf.join(', ')
  end
  
  def show_formatted_list(mvf)
    content_tag(:ul, :class => "item-mvf-list") do
      mvf.collect do |val|
        content_tag(:li, val)
      end.join.html_safe
    end
  end

  def list_is_empty?(arry)
    if arry.all? { |element| element.blank? }
      return true
    end
  end

end

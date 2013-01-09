module ApplicationHelper
  
  def on_scrollspy_page?
    on_background_page || on_inventory_pages
  end

  def show_list(mvf)
    mvf.join(', ')
  end
  
  def show_formatted_list(mvf,opts={})
    content_tag(:ul, :class => "item-mvf-list") do
      mvf.collect do |val|
        if opts[:facet]
          output=link_to(val,catalog_index_path(:"f[#{opts[:facet]}][]"=>"#{val}"))
        else
          output=val
        end
        content_tag(:li, output)
      end.join.html_safe
    end
  end

  def list_is_empty?(arry)
    if arry.all? { |element| element.blank? }
      return true
    end
  end

end

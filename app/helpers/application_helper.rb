module ApplicationHelper
  # take in a hash of options for the contact us form, and then pass the values of the hash through the translation engine
  def translate_options(options)
    result = {}
    options.each { |k, v| result.merge!(k => I18n.t(v)) }
    result
  end

  def show_image(image)
    image ? image : "https://dummyimage.com/100x100/F2F1EC/827A57&text=#{I18n.t('bassi.show.description_only')}"
  end

  def highlight_text(doc, field)
    doc.highlight_field(field) ? doc.highlight_field(field).first : doc[field]
  end

  def on_scrollspy_page?
    on_background_page || on_inventory_pages
  end

  # series descriptions always come in pairs, the first in italian, the second in english...depending on the language, show a particular version
  def show_series_language_description(mvf, language)
    notes = []
    mvf.each_with_index do |note, index|
      notes << note if (index.even? && language == :it) || (index.odd? && language == :en)
    end
    notes.join('<br /><br />')
  end

  def duplicate_note(itemref)
    return nil unless BassiVeratti::Application.config.duplicate_copies.keys.include?(itemref)
    I18n.t(BassiVeratti::Application.config.duplicate_copies[itemref][:note])
  end

  def duplicate_reference(itemref)
    return nil unless duplicate_note(itemref)
    BassiVeratti::Application.config.duplicate_copies[itemref][:duplicates]
  end

  def show_list(mvf)
    mvf.join(', ')
  end

  def show_formatted_list(mvf, opts = {})
    content_tag(:ul, :class => "item-mvf-list") do
      mvf.collect do |val|
        output = if opts[:facet]
                   link_to(val, search_catalog_path(:"f[#{opts[:facet]}][]" => val.to_s))
                 else
                   val
                 end
        content_tag(:li, output)
      end.join.html_safe
    end
  end

  def list_is_empty?(arry)
    return true if arry.all?(&:blank?)
  end

  def link_to_collection_highlight(highlight)
    link_to(highlight.send("name_#{I18n.locale}").to_s, search_catalog_path(params_for_collection_highlight(highlight)))
  end

  def params_for_collection_highlight(highlight)
    { :f => { "#{I18n.locale}_#{blacklight_config.collection_highlight_field}".to_sym => ["highlight_#{highlight.id}"] } }
  end

  def render_locale_class
    "lang-#{I18n.locale}"
  end
end

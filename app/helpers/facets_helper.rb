module FacetsHelper
  include Blacklight::FacetsHelperBehavior

  # Display-time filtering: en_document_types_ssim vs. it_document_types_ssim, for example.
  # Used in the catalog/_facets partial.
  # @param [Object] display_facet
  # @note This *could* be replaced by a pre-query filtering of the Blacklight config, such that
  #   Solr would not return unwanted facets, and display-time filtering would be unnecessary, but
  #   it is entirely functional as it is, and the direct manipulation of BL config per request is burdensome.
  def should_render_facet?(display_facet)
    facet_patterns = %w(document_types_ssim highlight_ssim)
    super && !(
      facet_patterns.any? { |facet_pattern| display_facet.name.include? facet_pattern } &&
      !display_facet.name.start_with?(I18n.locale.to_s + "_")
    )
  end
end

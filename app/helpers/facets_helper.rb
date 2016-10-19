module FacetsHelper
  include Blacklight::FacetsHelperBehavior

  # used in the catalog/_facets partial
  # REMOVE THIS when upgrading to Blacklight > 4.0.1 and use a before_filter in the CatalogController.
  # before_filter do
  #   configure_blacklight do |config|
  #     config.add_facet_field "#{I18n.locale}_document_types_ssim", :label => 'bassi.facet.document_types'
  #   end
  # end

  def should_render_facet?(display_facet)
    facet_patterns = %w(document_types_ssim highlight_ssim)
    super && !(
      facet_patterns.any? { |facet_pattern| display_facet.name.include? facet_pattern } &&
      !display_facet.name.include?(I18n.locale.to_s + "_")
    )
  end
end

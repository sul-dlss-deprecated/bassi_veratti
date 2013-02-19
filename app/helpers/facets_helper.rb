module FacetsHelper
  include Blacklight::FacetsHelperBehavior

  # used in the catalog/_facets partial
  # REMOVE THIS when upgrading to Blacklight > 4.0.1 and use a before_filter in the CatalogController.  
  # before_filter do 
  #   configure_blacklight do |config|
  #     config.add_facet_field "#{I18n.locale}_document_types_ssim", :label => 'bassi.facet.document_types'
  #   end
  # end
  
  def facet_field_names
    keys = blacklight_config.facet_fields.keys
    keys.delete_if{|k| k.include?(document_types_facet_pattern) }
    keys.unshift("#{I18n.locale}_#{document_types_facet_pattern}") 
  end

  private

  def document_types_facet_pattern
    "document_types_ssim"
  end
  
end
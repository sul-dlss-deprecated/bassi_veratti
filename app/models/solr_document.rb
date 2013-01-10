# -*- encoding : utf-8 -*-
class SolrDocument 

  include Blacklight::Solr::Document
  
  self.unique_key = 'id'

  def title
    self[:title_tsi]
  end
  
  def date
    multivalue_field('unit_date_ssim')
  end

  def description
    multivalue_field('extent_ssim')    
  end

  def people
    multivalue_field('personal_name_ssim')    
  end

  def families
    multivalue_field('family_name_ssim')
  end

  def corporations
    multivalue_field('corporate_name_ssim')
  end

  def location
    multivalue_field('geographic_name_ssim')
  end

  def notes
    multivalue_field('description_tsim')
  end
  
  def purl
    self[:purl_ssi]
  end
  
  def level
    multivalue_field(blacklight_config.folder_identifier_field).first
  end

  def series
    multivalue_field('series_ssim').first
  end
          
  def box
    multivalue_field(blacklight_config.box_identifying_field).first
  end

  def folder
    multivalue_field(blacklight_config.folder_identifying_field).first    
  end
  
	def multivalue_field(name)
	  self[name.to_sym].nil? ? ['']: self[name.to_sym]
  end

  def images(size=:default)
    return [] unless self.has_key?(blacklight_config.image_identifier_field)
    stacks_url = BassiVeratti::Application.config.stacks_url
    self[blacklight_config.image_identifier_field].map do |image_id|
      "#{stacks_url}/#{self["druid_ssi"]}/#{image_id.chomp('.jp2')}#{SolrDocument.image_dimensions[size]}.jpg"
    end
  end

  def first_image(size=:default)
    return "http://placehold.it/100x100" unless self.has_key?(blacklight_config.image_identifier_field)
    stacks_url = BassiVeratti::Application.config.stacks_url
    images(size).first
  end
  
   def self.image_dimensions
     options = {:default => "_thumb",
                :square   => "_square",
                :thumb => "_thumb" }
   end
  
  def series?
    self.has_key?(blacklight_config.series_identifying_field) and 
      self[blacklight_config.series_identifying_field].include?(blacklight_config.series_identifying_value)
  end
  
  def folder?
    self.has_key?(blacklight_config.folder_identifier_field) and 
      self[blacklight_config.folder_identifier_field].include?(blacklight_config.folder_identifier_value)
  end
  
  def folders
    return nil unless series?
    @folders ||= CollectionMembers.new(
                              Blacklight.solr.select(
                                :params => {
                                  :fq => "#{blacklight_config.folder_identifier_field}:\"#{blacklight_config.folder_identifier_value}\" AND 
                                          #{blacklight_config.folder_in_series_identifying_field}:\"#{self[SolrDocument.unique_key]}\"",
                                  :rows => blacklight_config.collection_member_grid_items.to_s
                                }
                              )
                            )
  end

  def parent
    return nil if series?
    @parent ||= SolrDocument.new(
                      Blacklight.solr.select(
                        :params => {
                          :fq => "#{SolrDocument.unique_key}:\"#{self[blacklight_config.children_identifying_field].first}\""
                        }
                      )["response"]["docs"].first
                    )
  end

  def children
    if folder?
      @children ||= CollectionMembers.new(
                                Blacklight.solr.select(
                                  :params => {
                                    :fq => "#{blacklight_config.parent_folder_identifying_field}:\"#{self[SolrDocument.unique_key]}\"",
                                    :rows => blacklight_config.collection_member_grid_items.to_s
                                  }
                                )
                              )    
    else
      @children ||= CollectionMembers.new(
                                Blacklight.solr.select(
                                  :params => {
                                    :fq => "#{blacklight_config.children_identifying_field}:\"#{self[SolrDocument.unique_key]}\"",
                                    :rows => blacklight_config.collection_member_grid_items.to_s
                                  }
                                )
                              )
    end
    
  end
  
  def box_siblings
    @box_siblings ||= CollectionMembers.new(
                              Blacklight.solr.select(
                                :params => {
                                  :fq => "#{blacklight_config.box_identifying_field}:\"#{self[blacklight_config.box_identifying_field].first}\"",
                                  :rows => blacklight_config.collection_member_grid_items.to_s
                                }
                              )
                            )
  end

  def folder_siblings
    @folder_siblings ||= CollectionMembers.new(
                              Blacklight.solr.select(
                                :params => {
                                  :fq => "#{blacklight_config.box_identifying_field}:\"#{self.box}\" AND
                                          #{blacklight_config.folder_identifying_field}:\"#{self.folder}\" AND NOT id:\"#{self.id}\" AND NOT id:\"box#{self.box}-folder#{self.folder}\""                                }
                              )
                            )
  end

  def all_series
    @all_series ||= Blacklight.solr.select(
      :params => {
        :fq => "#{blacklight_config.series_identifying_field}:\"#{blacklight_config.series_identifying_value}\"",
        :rows => "20"
      }
    )["response"]["docs"].map do |document|
      SolrDocument.new(document)
    end
  end


  def collection?
    self.has_key?(blacklight_config.collection_identifying_field) and 
      self[blacklight_config.collection_identifying_field].include?(blacklight_config.collection_identifying_value)
  end
  
  def collection_member?
    self.has_key?(blacklight_config.collection_member_identifying_field) and 
      !self[blacklight_config.collection_member_identifying_field].blank?
  end
  
  # return this current document's series title (unless it is already a series)
  def series_title
    return self.title if self.series?
    @doc=SolrDocument.new(Blacklight.solr.select(:params => {:fq => "#{SolrDocument.unique_key}:#{self.series}"})["response"]["docs"].first)  
    return @doc.title
  end
  
  def series_number
    series_title[0]
  end
  
  # Return a SolrDocument object of the parent collection of a collection member
  def collection
    return nil unless collection_member?
    @collection ||= SolrDocument.new(
                      Blacklight.solr.select(
                        :params => {
                          :fq => "#{SolrDocument.unique_key}:\"#{self[blacklight_config.collection_member_identifying_field].first}\""
                        }
                      )["response"]["docs"].first
                    )
  end
  
  # Return a CollectionMembers object of all the members of a collection
  def collection_members
    return nil unless collection?
    @collection_members ||= CollectionMembers.new(
                              Blacklight.solr.select(
                                :params => {
                                  :fq => "#{blacklight_config.collection_member_identifying_field}:\"#{self[SolrDocument.unique_key]}\"",
                                  :rows => blacklight_config.collection_member_grid_items.to_s
                                }
                              )
                            )
  end
  
  # Return a CollectionMembers object of all of the siblins a collection member (including self)
  def collection_siblings
    return nil unless collection_member?
    @collection_siblings ||= CollectionMembers.new(
                               Blacklight.solr.select(
                                 :params => {
                                   :fq => "#{blacklight_config.collection_member_identifying_field}:\"#{self[blacklight_config.collection_member_identifying_field].first}\"", 
                                   :rows => blacklight_config.collection_member_grid_items.to_s
                                 }
                               )
                             )
  end
  
  # Return an Array of collection SolrDocuments
  def all_collections
    @all_collections ||= Blacklight.solr.select(
      :params => {
        :fq => "#{blacklight_config.collection_identifying_field}:\"#{blacklight_config.collection_identifying_value}\"",
        :rows => "10"
      }
    )["response"]["docs"].map do |document|
      SolrDocument.new(document)
    end
  end
  
  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_display
  extension_parameters[:marc_format_type] = :marcxml
  use_extension( Blacklight::Solr::Document::Marc) do |document|
    document.key?( :marc_display  )
  end
  
  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Email )
  
  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Solr::Document::ExtendableClassMethods#field_semantics
  # and Blacklight::Solr::Document#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Solr::Document::DublinCore)    
  field_semantics.merge!(    
                         :title => "title_tsi",
                         :author => "author_display",
                         :language => "language_facet",
                         :format => "format_ssim"
                         )

                         
  private
  
  def blacklight_config
    CatalogController.blacklight_config
  end
end

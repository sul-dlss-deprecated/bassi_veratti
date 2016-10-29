# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain += [:exclude_document_level_folders]

  def exclude_document_level_folders(solr_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << 'NOT folder_is_content_bi:true'
  end
end

# -*- encoding : utf-8 -*-
class CatalogController < ApplicationController
  include Blacklight::Catalog

  def self.collection_highlights(locale)
    opts = {}
    # I think we actually do want the entire table loaded into memory here at once, i.e. not `find_each`
    CollectionHighlight.order(:sort_order).each do |highlight|
      opts[:"highlight_#{highlight.id}"] = { :label => highlight.send("name_#{locale}"), :fq => "id:(#{highlight.query.gsub('or', 'OR')})" }
    end if ActiveRecord::Base.connection.table_exists? 'collection_highlights'
    opts
  end

  def index
    @params = params
    if on_home_page
      @highlights = CollectionHighlight.order("sort_order").limit(3)

      # get all documents, iterate over those with coordinates, and build the content needed to show on the map
      # this is all fragment cached, so its only done once
      unless fragment_exist?(:controller => 'catalog', :action => 'index', :action_suffix => 'map') || @params[:nomap]
        @document_locations = {}
        location_facets = Blacklight.default_index.connection.get 'select', :params => { :q => '*:*', :rows => 0, :facet => true, :'facet.field' => 'geographic_name_ssim' }
        location_names = location_facets['facet_counts']['facet_fields']['geographic_name_ssim']
        location_names.each_with_index do |location_name, index|
          next unless index.even? && !BassiVeratti::Application.config.no_geocode.include?(location_name)
          # puts "*** looking up #{location_name} with #{location_names[index+1]} numbers"
          lookup_name = BassiVeratti::Application.config.geocode_swap[location_name] || location_name
          results = Geocoder.search(lookup_name)
          sleep 0.3 # don't overload the geolookup API
          unless results.empty?
            @document_locations.merge!(location_name => { :lat => results.first.latitude, :lon => results.first.longitude, :count => location_names[index + 1] })
          end
        end
      end
    end

    @highlights = CollectionHighlight.order("sort_order") if on_collection_highlights_page
    super
  end

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => 'standard',
      :facet => 'true',
      :rows => 10,
      :fl => "*",
      :"facet.mincount" => 1,
      :echoParams => "all"
    }

    # various Bassi Veratti specific collection field configurations
    config.collection_highlight_field = "highlight_ssim"

    # needs to be stored so we can retreive it
    # needs to be in field list for all request handlers so we can identify collections in the search results.
    config.series_identifying_field = "level_ssim"
    config.series_identifying_value = "series"

    config.collection_identifying_field = "format_ssim"
    config.collection_identifying_value = "Collection"

    # needs to be stored so we can retreive it for display.
    # needs to be in field list for all request handlers.
    config.collection_description_field = "description_tsim"

    # needs to be indexed so we can search it to return relationships.
    # needs to be in field list for all request handlers so we can identify collection members in the search results.
    config.children_identifying_field = "direct_parent_ssim"

    config.collection_member_identifying_field = "is_member_of_ssim"

    config.box_identifying_field = "box_ssim"
    config.folder_identifying_field = "folder_ssim"

    config.folder_identifier_field = "level_ssim"
    config.folder_identifier_value = "Folder"

    config.parent_folder_identifying_field = "parent_folder_ssim"

    config.folder_in_series_identifying_field = "series_ssim"

    # needs to be stored so we can retreive it for display
    # needs to be in field list for all request handlers
    config.collection_member_collection_title_field = "collection_ssim"

    config.collection_member_grid_items = 1000

    # needs to be stored so we can retreive it
    # needs to be in field list for all request handlers so we can get images the document anywhere in the app.
    config.image_identifier_field = "image_id_ssim"

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    config.default_document_solr_params = {
      :qt   => 'standard',
      :fl   => '*',
      :rows => 1,
      :q    => '{!raw f=id v=$id}'
    }

    config.document_index_view_types = %w(default gallery brief map)

    # solr field configuration for search results/index views
    config.index.title_field        = 'title_tsi'
    config.index.display_type_field = 'format_ssim'

    # solr field configuration for document/show views
    config.show.title_field        = 'title_tsi'
    config.show.display_type_field = 'format_ssim'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'en_document_types_ssim', label: :'bassi.facet.document_types'
    config.add_facet_field 'it_document_types_ssim', label: :'bassi.facet.document_types'
    config.add_facet_field 'personal_name_ssim', :label => :'bassi.facet.personal_name', :limit => 10
    config.add_facet_field 'geographic_name_ssim', :label => :'bassi.facet.location', :limit => 10
    config.add_facet_field 'corporate_name_ssim', :label => :'bassi.facet.corporate_name', :limit => 10
    config.add_facet_field 'family_name_ssim', :label => :'bassi.facet.family_name'
    config.add_facet_field 'date_range_itim', :label => :'bassi.facet.date_range', :range => true

    config.add_facet_field 'en_highlight_ssim', :label => :'bassi.nav.collections', :show => false, :query => collection_highlights('en')
    config.add_facet_field 'it_highlight_ssim', :label => :'bassi.nav.collections', :show => false, :query => collection_highlights('it')

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display

    config.add_index_field 'document_types_ssim', :label => :'bassi.show.document_types', :highlight => true
    config.add_index_field 'unit_date_ssim', :label => :'bassi.show.date', :highlight => true

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'document_types_ssim', :label => :'bassi.show.document_types'
    config.add_show_field 'unit_date_ssim', :label => :'bassi.show.date'
    config.add_show_field 'extent_ssim', :label => :'bassi.show.physical_description'
    config.add_show_field 'description_tsim', :label => :'bassi.show.notes'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  # Email Action (this will render the appropriate view on GET requests and process the form and send the email on POST requests)
  def email
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    if request.post?
      if params[:to]
        url_gen_params = { :host => request.host_with_port, :protocol => request.protocol }

        if params[:to] =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
          email = RecordMailer.email_record(@documents, { :to => params[:to], :message => params[:message] }, url_gen_params)
        else
          flash[:error] = I18n.t('blacklight.email.errors.to.invalid', :to => params[:to])
        end
      else
        flash[:error] = I18n.t('blacklight.email.errors.to.blank')
      end

      unless flash[:error]
        email.deliver
        flash[:success] = "Email sent"
        if request.xhr?
          render :email_sent, :formats => [:js]
          return
        else
          redirect_to solr_document_path(params['id'])
        end
      end
    end

    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end
end

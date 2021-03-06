# -*- encoding : utf-8 -*-
#
class CatalogController < ApplicationController  

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10 
    }
    
    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select' 
    
    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or 
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
      :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}' 
    }

    # solr field configuration for search results/index views
    #config.index.title_field = 'title_display'
    #config.index.display_type_field = 'format'
    config.index.show_link = 'title_s'
    config.index.record_display_type = 'url_s'

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'
    config.show.html_title = 'title_s'
    config.show.heading = 'title_s'
    config.show.subject = 'subject_s'

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
    #config.add_facet_field 'format', :label => 'Format'
    #config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    #config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20 
    #config.add_facet_field 'language_facet', :label => 'Language', :limit => true 
    #config.add_facet_field 'lc_1letter_facet', :label => 'Call Number' 
    #config.add_facet_field 'subject_geo_facet', :label => 'Region' 
    #config.add_facet_field 'subject_era_facet', :label => 'Era'  
    config.add_facet_field 'adaptationtype_s', :label => 'Adaptation Type', :limit => true
    config.add_facet_field 'accessmode_s', :label => 'Access Mode' 
    config.add_facet_field 'resourcetype_s', :label => 'Resource Type'
    config.add_facet_field 'language_s', :label => 'Language', :limit => true 
    config.add_facet_field 'audience_s', :label => 'Audience', :limit => 20 
    config.add_facet_field 'educationlevel_s', :label => 'Education Level' 

    #config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    #config.add_facet_field 'publication_date_query', :label => 'Publish Date', :query => {
    #   :years_5 => { :label => 'within 5 Years', :fq => "publication_date_s:[#{Time.now.year - 5 } TO *]" },
    #   :years_10 => { :label => 'within 10 Years', :fq => "publication_date_s:[#{Time.now.year - 10 } TO *]" },
    #   :years_25 => { :label => 'within 25 Years', :fq => "publication_date_s:[#{Time.now.year - 25 } TO *]" }
    #}
    config.add_facet_field 'custom_query', :label => 'Accessible Resources', :query => {
      :useful_without_sound => { :label => 'Useful Without Sound', :fq => '-(accessmode_s:auditory -adaptationtype_s:captions -adaptation_s:transcript)' },
      :useful_without_vision => { :label => 'Useful Without Vision', :fq => '-(-adaptationtype_s:audioDescription -adaptationtype_s:longDescription -adaptationtype_s:shortDescription accessmode_s:visual)' },
      :useful_without_color_vision => { :label => 'Useful Without Color Vision', :fq => '-accessmode_s:colour'}
    }


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    #config.add_index_field 'title_display', :label => 'Title'
    #config.add_index_field 'title_vern_display', :label => 'Title'
    #config.add_index_field 'author_display', :label => 'Author'
    #config.add_index_field 'author_vern_display', :label => 'Author'
    #config.add_index_field 'format', :label => 'Format'
    #config.add_index_field 'language_facet', :label => 'Language'
    #config.add_index_field 'published_display', :label => 'Published'
    #config.add_index_field 'published_vern_display', :label => 'Published'
    #config.add_index_field 'lc_callnum_display', :label => 'Call number'
    #config.add_index_field 'title_s', :label => 'Title'
    #config.add_index_field 'description_s', :label => 'Description'
    config.add_index_field 'adaptationtype_s', :label => 'Adaptation Type'
    config.add_index_field 'accessmode_s', :label => 'Access Mode'
    config.add_index_field 'url_s', :label => 'URL' 
    config.add_index_field 'isadaptationof_s', :label => 'Is Adaptation Of'
    config.add_index_field 'subject_s', :label => 'Subjects'
    config.add_index_field 'educationlevel_s', :label => 'Education Level'
    config.add_index_field 'audience_s', :label => 'Audience' 
    config.add_index_field 'resourcetype_s', :label => 'Resource Type'  
    config.add_index_field 'language_s', :label => 'Language'
    config.add_index_field 'publicationdate_s', :label => 'Publication Date'
    config.add_index_field 'rights_s', :label => 'Rights'
    config.add_index_field 'accessRights_s', :label => 'Access Rights'
    config.add_index_field 'contributer_s', :label => 'Contributers'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    #config.add_show_field 'title_display', :label => 'Title'
    #config.add_show_field 'title_vern_display', :label => 'Title'
    #config.add_show_field 'subtitle_display', :label => 'Subtitle'
    #config.add_show_field 'subtitle_vern_display', :label => 'Subtitle'
    #config.add_show_field 'author_display', :label => 'Author'
    #config.add_show_field 'author_vern_display', :label => 'Author'
    #config.add_show_field 'format', :label => 'Format'
    #config.add_show_field 'url_fulltext_display', :label => 'URL'
    #config.add_show_field 'url_suppl_display', :label => 'More Information'
    #config.add_show_field 'language_facet', :label => 'Language'
    #config.add_show_field 'published_display', :label => 'Published'
    #config.add_show_field 'published_vern_display', :label => 'Published'
    #config.add_show_field 'lc_callnum_display', :label => 'Call number'
    #config.add_show_field 'isbn_t', :label => 'ISBN'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    #config.add_search_field 'all_fields', :label => 'All Fields'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    #config.add_search_field('title_s', :label => 'Title') do |field|
    #  # solr_parameters hash are sent to Solr as ordinary url query params. 
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'default' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
    #  field.solr_local_parameters = { 
    #    :qf => '$title_qf',
    #    :pf => '$title_pf'
    #  }
    #end

    #config.add_search_field('resourcetype_s', :label => 'Resource Type') # do |field|
      # field.solr_parameters = { :'spellcheck.dictionary' => 'resourcetype_s'  }
      # field.solr_local_parameters = { 
      #   :qf => '$resourcetype_s_qf',
      #   :pf => '$resourcetype_s_pf'
      # }
    # end
    
    #config.add_search_field('author') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
    #  field.solr_local_parameters = { 
    #    :qf => '$author_qf',
    #    :pf => '$author_pf'
    #  }
    #end
    
    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as 
    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
    #config.add_search_field('subject') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
    #  field.qt = 'search'
    #  field.solr_local_parameters = { 
    #    :qf => '$subject_qf',
    #    :pf => '$subject_pf'
    #  }
    #end
    #config.add_search_field('description_t', :label => 'Description') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
    #  field.qt = 'search'
    #  field.solr_local_parameters = { 
    #    :qf => '$description_t',
    #    :pf => '$description_t'
    #   }
    #end

    #config.add_search_field('educationlevel', :label => 'Education Level') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'default'  }
    #   field.solr_local_parameters = { 
    #     :qf => '$educationlevel_t',
    #     :pf => '$educationlevel_t'
    #   }
    #end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, publicationdate_s desc, title_s asc', :label => 'Relevance'
    #config.add_sort_field 'publicationdate_sort desc, title_sort asc', :label => 'year'
    #config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_s asc, publicationdate_s desc', :label => 'Title'
    #config.add_sort_field 'accessmode_sort asc, title_s asc', :label => 'Access Mode'
    #config.add_sort_field 'adaptationtype_sort asc, title_s asc', :label => 'Adaptation Type'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end 

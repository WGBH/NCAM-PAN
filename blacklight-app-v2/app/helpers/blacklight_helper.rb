module BlacklightHelper
 include Blacklight::BlacklightHelperBehavior

  # overrides default link_to_document method, uses url_s for the solr document and opens in a new window
  def link_to_document(doc, opts={:label=>nil, :counter => nil})
    opts[:label] ||= document_show_link_field(doc)
    label = render_document_index_label doc, opts
    link_to label, doc[:url_s], target: '_blank'
  end

  ##
  # Determine whether to render a given field in the index view.
  #  
  # @param [SolrDocument] document
  # @param [Blacklight::Solr::Configuration::SolrField] solr_field
  # @return [Boolean]
  def should_render_index_field? document, solr_field
    should_render_field?(solr_field, document) && document_has_value?(document, solr_field) && solr_field.field != "adaptationtype_s"
  end
end
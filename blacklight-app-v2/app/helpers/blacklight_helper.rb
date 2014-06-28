module BlacklightHelper
  include Blacklight::UrlHelperBehavior

  # overrides default link_to_document method, uses url_s for the solr document and opens in a new window
  def link_to_document(doc, opts={:label=>nil, :counter => nil})
    opts[:label] ||= document_show_link_field(doc)
    label = render_document_index_label doc, opts
    link_to label, doc[:url_s], target: '_blank'
  end
end
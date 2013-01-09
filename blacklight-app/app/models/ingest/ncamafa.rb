class Ingest::Ncamafa < Ingest::Xml
  def records
    xml.xpath("//xmlns:record", xmlns)
  end

  def content
    super.gsub(/(<\/?[A-Za-z0-9_]+):/) { $1 }
  end

  protected  
  def records_xpath
    "//xmlns:record"
  end

  def record_unique_id
    "//xmlns:recordID"
  end
  def process_record row, solr_doc = nil
    solr_doc ||= {}
    fields = []
    row.xpath('xmlns:record').children.children.select.each do |node|
#    row.xpath("//xmlns:record").children.children.select { |x| !x.text.nil? }.each do |node|
#      case node.name
#        when "educationLevel"
#          node.xpath("xmlns:educationLevel", "xml.namespaces").each do |educationLevel|
#            fields << ['educationLevel_s', educationLevel.text]
#          end
#        when "resourceType"
#          node.xpath("xmlns:resourceType", "xml.namespaces").each do |resourceType|
#            fields << ['resourceType_s', resourceType.text]
#          end
#        when "rights"
#          node.xpath("xmlns:rights", "xml.namespaces").each do |rights|
#            fields << ['rights_s', rights.text]
#          end
#        when "contributor"
#          node.xpath("xmlns:contributor", "xml.namespaces").each do |contributor|
#            fields << ['contributor_s', contributor.text]
#          end
#        when "accessMode"
#          node.xpath("xmlns:accessMode", "xml.namespaces").each do |accessMode|
#            fields << ['accessMode_s', accessMode.text]
#          end
#        when "adaptationType"
#          node.xpath("xmlns:adaptationType", "xml.namespaces").each do |adaptationType|
#            fields << ['adaptationType_s', adaptationType.text]
#          end
#
#        else
          fields << ["#{node.name.parameterize}_s", node.text] if node.name != "text"
#      end
    end

    fields.each do |key, value|
      next if value.blank?
      key.gsub!('__', '_')
      solr_doc[key.to_sym] ||= []
      solr_doc[key.to_sym] << value.strip
    end

    solr_doc
  end
end


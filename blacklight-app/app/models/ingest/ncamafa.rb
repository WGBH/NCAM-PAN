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
    solr_doc[:id] ||= row.xpath(record_unique_id, xmlns).text.to_s
    #row.xpath('xmlns:record').children.children.select.each do |node|
    row.xpath("*").select { |x| !x.text.nil? }.each do |section|
      section.children.each do |node|
        case node.name
          when record_unique_id  #"recordID"
            solr_doc[:id] = node.text 
            #fields << [node.name, node.text] if node.name != "text"
          else
            fields << ["#{node.name.parameterize}_s", node.text] if node.name != "text"
        end
      end
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


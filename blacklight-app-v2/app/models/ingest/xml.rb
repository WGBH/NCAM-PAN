require 'nokogiri'

class Ingest::Xml < Ingest::Base
  def xml
    @xml ||= Nokogiri::XML(content)
  end

  def records
    xml.xpath("//xmlns:ROW", xmlns)
  end

  def xmlns
    xml.namespaces
  end

  def process! opts = {}
    run_callbacks(:process) do
      records.each do |row|
        solr_doc = {}

        run_callbacks(:process_record) do

          process_record(row, solr_doc)

          #solr_doc[:id] ||= row.xpath(record_unique_id, xmlns).text.to_s
          
          solr_doc[:xml_display_s] = row.to_s

        end
        
        print solr_doc.to_s
        Blacklight.solr.add solr_doc, :add_attributes => { :commitWithin => 10000 }
        Blacklight.solr.commit
      end
    end
  end

  def record_unique_id
    "@RECORDID"
  end

  def process_record(row, solr_doc = {})
    solr_doc ||= {}
    fields = []
    row.xpath("*").select { |x| !x.text.blank? }.each do |node|
      fields << ["#{node.name.parameterize}_s", node.text]
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


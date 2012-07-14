class GEXF::XmlSerializer

  GEXF_ATTRS = {
    'xmlns'     => '"http://www.gexf.net/1.2draft',
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
    'xsi'       => 'http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd',
    'version'   => '1.2'
  }

  def initialize(graph)
    @graph    = graph
    @document = nil
  end

  def serialize!
    document.to_xml
  end

private
  def g
    @graph
  end

  def graph_attributes
    { :defaultedgetype   => g.defaultedgetype,
      :idtype            => g.idtype,
      :mode              => g.mode }
  end

  def build_attributes(xml)
    %w(nodes edges).each do |type|
      xml.attributes(:class => type.gsub(/s$/,'')) {
        g.send(type).defined_attributes.map do |id, attr| 
          xml.attribute(attr.to_hash)
        end
      }
    end
  end

  def build_nodes(xml)
    build_collection(xml, 'nodes')
  end

  def build_edges(xml)
    build_collection(xml, 'edges')
  end

  def build_collection(xml, collection_name, tagname=nil)
    tagname ||= collection_name.gsub /s$/,''

    xml.send(collection_name) do
      g.send(collection_name).each do |item|
        build_item(xml, item, tagname)
      end
    end
  end

  def build_item(xml, item, tagname)
    if item.attr_values.any?
      xml.send(tagname, item.to_hash) do
        item.attr_values.each do |id, value|
          value = value.join('|') if value.respond_to?(:join)
          xml.attrvalue(:for => id, :value => value)
        end
      end
    else
      xml.send(tagname, item.to_hash)
    end
  end

  def document
    @document ||= build do |xml|
      xml.gexf(GEXF_ATTRS) do
        xml.graph(graph_attributes) do
          build_attributes(xml) 
          build_nodes(xml)
          build_edges(xml)
        end
      end
    end
  end

  def build(&block)
    Nokogiri::XML::Builder.new(:encoding => 'UTF-8', &block)
  end
end

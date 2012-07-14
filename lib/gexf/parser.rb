class GEXF::Document < Nokogiri::XML::SAX::Document

  def start_document
    @graphs           = []
    @graph            = nil
    @node             = nil
    @edge             = nil
    @attr_class       = nil
    @defined_attrs    = {}
  end

  def start_element(tagname, attributes)
    dispatch(tagname, sanitize_attrs(attributes))
  end

  def end_element(tagname)
    case tagname
    when 'graph'
      @graph          = nil
    when 'attributes'
      @attr_class     = nil
    when 'node'
      @node           = nil
    when 'edge'
      @edge           = nil
    end
  end

private
   def dispatch(tagname, attributes)
     case tagname
     when 'graph'
       on_graph_start(attributes)
     when 'attributes'
       @attr_class = attributes[:class]
     when 'attribute'
       on_attribute_start(attributes)
     when 'attrvalue'
       on_attrvalue_start(attributes)
     when 'node'
       on_node_start(attributes)
     when 'edge'
       on_edge_start(attributes)
     end
   end

   def sanitize_attrs(attributes)
     Hash[*attributes.flatten].
       symbolize_keys.
       symbolize_graph_types
   end

   def on_graph_start(attributes)
     @graphs << @graph = GEXF::Graph.new(attributes)
   end

   def on_attribute_start(definition)
     title      = definition.delete(:title)
     type       = definition[:type]
     definition.delete(:class)

     attr = case @attr_class
            when 'node'
              graph.define_node_attribute(title, definition)
            when 'edge'
              graph.define_edge_attribute(title, definition)
            end

     @defined_attrs[attr.id] = attr.title
   end

   def on_node_start(attributes)
     @node = graph.create_node(attributes)
   end

   def on_edge_start(attributes)
     source_id = attributes.delete(:source)
     target_id = attributes.delete(:target)

     source    = graph.nodes[source_id]
     target    = graph.nodes[target_id]

     @edge = graph.create_edge(source, target, attributes)
   end

   def on_attrvalue_start(attrs)
     attr_id = attrs[:for]

     if @defined_attrs[attr_id]
       @node.set_attr_by_id(attr_id, attrs[:value])
     else
       warn "Cannot find an attribute with id: #{id}"
     end
   end

   def graph
     @graph
   end
end

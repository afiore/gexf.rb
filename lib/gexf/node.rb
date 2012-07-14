class GEXF::Node
  extend Forwardable
  include GEXF::Attribute::Assignable

  attr_reader :id, :label

  def_delegators :@graph, :edgetype

  def initialize(id, graph, opts={})
    @graph       = graph
    @id          = id_type(id)
    @label       = opts[:label] || @id

    # see GEXF::Attribute::Assignable
    @collection  = graph.nodes
    @attr_values = {}

    set_attributes(opts.fetch(:attributes, {}))
  end

  def connect_to(target, opts={})
    graph.nodes << target
    graph.create_edge(self, target, opts)
  end

  def create_and_connect_to(target_attr, opts={})
    node = graph.create_node(target_attr)
    connect_to(node, opts)
    node
  end

  def connections(type=nil)
    graph.edges[self.id].to_a
  end

  def to_hash
    {:id => id, :label => label}
  end

private
  def set_attributes(attributes={})
    attributes.each { |attr,value| self[attr]=value }
  end

  def id_type(id)
    graph.idtype == GEXF::Graph::INTEGER ? id.to_i : id.to_s
  end

  def graph
    @graph
  end
end

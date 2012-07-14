class GEXF::Graph

  STRING    = :string
  INTEGER   = :integer
  IDTYPES   = [STRING, INTEGER]

  STATIC    = :static
  DYNAMIC   = :dynamic
  MODES     = [STATIC, DYNAMIC]

  EDGETYPES = GEXF::Edge::TYPES

  attr_reader :edgetype, :idtype, :mode, :nodes, :edges

  def initialize(opts={})
    edgetype   = opts[:edgetype] || GEXF::Edge::UNDIRECTED
    idtype     = opts[:idtype]   || STRING
    mode       = opts[:mode]     || STATIC
    id_counter = Struct.new(:nodes, :edges, :attributes)

    raise ArgumentError.new "Invalid edgetype: '#{edgetype}'" unless EDGETYPES.include?(edgetype)
    raise ArgumentError.new "Invalid idtype: '#{idtype}'"     unless IDTYPES.include?(idtype)
    raise ArgumentError.new "Invalid mode: '#{mode}'"         unless MODES.include?(mode)

    @edgetype   = edgetype
    @idtype     = idtype
    @mode       = mode
    @id_counter = id_counter.new(0,0,0)
    @attributes = {}

    @nodes      = GEXF::NodeSet.new
    @edges      = GEXF::EdgeSet.new
  end

  def defined_attributes
    nodes.defined_attributes.merge(edges.defined_attributes)
  end

  def define_node_attribute(title, opts={})
    id                = assign_id(:attributes, opts.delete(:id)).to_s
    @nodes.define_attribute(id, title, opts)
  end

  def define_edge_attribute(title, opts={})
    id                = assign_id(:attributes, opts.delete(:id)).to_s
    @edges.define_attribute(id, title, opts)
  end

  def create_node(opts={})
    id                = assign_id(:nodes, opts.delete(:id))
    @nodes << node    = GEXF::Node.new(id, self, opts)
    node
  end

  def create_edge(source, target, opts={})
    opts[:type]       ||= edgetype
    id                = assign_id(:edges, opts.delete(:id))
    @edges << edge    = GEXF::Edge.new(id, source.id, target.id, opts.merge(:graph => self))
    edge
  end

  def attribute_definitions
    @attributes.dup
  end

private
  def assign_id(counter_name, id=nil)
    auto_id = @id_counter.send(counter_name) + 1

    if !id
      id = auto_id
      @id_counter.send("#{counter_name}=", id)
    end

    cast_id(id)
  end

  def cast_id(id)
    @idtype == INTEGER ? id.to_i : id.to_s
  end

end

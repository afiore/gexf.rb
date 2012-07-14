class GEXF::Edge
  include GEXF::Attribute::Assignable

  DIRECTED   = :directed
  UNDIRECTED = :undirected
  MUTUAL     = :mutual

  TYPES = [ DIRECTED, UNDIRECTED, MUTUAL]

  attr_reader :id, :source_id, :target_id, :weight, :type, :label

  def initialize(id, source_id, target_id, opts={})

    type      = opts[:type] || UNDIRECTED
    weight    = opts[:weight] && opts[:weight].to_f
    graph     = opts[:graph]
    label     = opts[:label] && opts[:label].to_s || nil
    id        = id.to_s
    source_id = source_id.to_s
    target_id = target_id.to_s

    raise ArgumentError.new("Invalid type: #{type}")                          if !TYPES.include?(type)
    raise ArgumentError.new("'weight' should be a positive, numerical value") if weight && weight < 0.1
    raise ArgumentError.new("Missing graph")                                  if !graph
    raise ArgumentError.new("Missing id")                                     if !id     || id.empty?
    raise ArgumentError.new("Missing source_id")                              if !source_id || source_id.empty?
    raise ArgumentError.new("Missing target_id")                              if !target_id || target_id.empty?

    @id          = id.to_s
    @label       = label
    @type        = type
    @source_id   = source_id.to_s
    @target_id   = target_id.to_s
    @weight      = weight || 1.0
    @graph       = graph
    # see GEXF::Attribute::Assignable
    @collection  = @graph.edges
    @attr_values = {}

    set_attributes(opts.fetch(:attributes, {}))
  end

  [:directed, :undirected, :mutual].each do |type|
    define_method("#{type}?") do
      @type == self.class.const_get(type.to_s.upcase)
    end
  end

  def target
    @graph.nodes[target_id]
  end

  def source
    @graph.nodes[source_id]
  end

  def to_hash
    optional = {}
    optional[:label] = label if label && !label.empty?

    {:id => id,
     :source => source_id,
     :target => target_id,
     :type => type

    }.merge(optional)
  end

private
  def set_attributes(attributes={})
    attributes.each { |attr,value| self[attr]=value }
  end
end

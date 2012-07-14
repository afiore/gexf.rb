class GEXF::NodeSet < Set
  extend Forwardable
  include GEXF::Attribute::Definable

  def_delegators :@hash, :[], :fetch, :keys, :values

  def <<(node)
    @hash[node.id] = node if node.is_a?(GEXF::Node)
  end

  def each(&block)
    @hash.values.each(&block)
  end

  def inspect
    "<GEXF::NodeSet #{@hash.keys}>"
  end

end

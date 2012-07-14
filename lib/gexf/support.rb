GEXF::GRAPH_TYPES = (GEXF::Attribute::TYPES   +
                     GEXF::Edge::TYPES        +
                     GEXF::Graph::IDTYPES     +
                     GEXF::Graph::MODES).uniq

class Hash
  def symbolize_keys
    hash = {}
    each { |k,v| hash[k.to_sym] = delete(k) }
    merge(hash)
  end

  def symbolize_graph_types
    hash = {}
    each { |k, v| hash[k] = delete(k).to_sym if GEXF::GRAPH_TYPES.include?(v.to_sym) }
    merge(hash)
  end
end

class GEXF::DSL

  def initialize(graph, counter=0)
    @graph   = graph
    @counter = counter
  end

  def next_id!
    @counter += 1
    @counter.to_s
  end

  def next_id
    (@counter + 1).to_s
  end

private
  def graph
    @graph
  end
end

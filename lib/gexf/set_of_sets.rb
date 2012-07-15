class GEXF::SetOfSets < Set
  extend ::Forwardable
  include GEXF::Attribute::Definable

  def_delegators :@hash, :empty?

  def [](node_id)
    @hash[node_id]
  end

  def to_a
    uniq_items
  end

  def to_hash
    @hash
  end

  def each(&block)
    uniq_items.each(&block)
  end

  [:size, :count, :length].each do |method|
    define_method(method) do
      uniq_items.count
    end
  end

private
  def append_to_key(key, value)
    @hash[key] ||= Set.new
    @hash[key] << value
  end

  def uniq_items
    @hash.map {| _, v| v.to_a }.flatten.uniq
  end
end

module GEXF::Attribute::Definable

  def define_attribute(id, title, opts={})
    @attribute_definitions ||= {}
    @attribute_definitions[id] = GEXF::Attribute.new(id, title, opts)
  end

  def attributes
    Hash[*map do |item|
      attributes = item.attributes
      [item.id, attributes] if attributes && attributes.any?
     end.compact.flatten]
  end

  def attribute_definitions
    @attribute_definitions ||= {}
  end

  alias_method :defined_attributes, :attribute_definitions
end

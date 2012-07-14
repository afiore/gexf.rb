module GEXF::Attribute::Assignable 

  # Delegates calls for the 'defined_attributes' method to the @collection instance variable
  #
  # Returns nothing.

  def self.included(base)
    base.extend(Forwardable) unless base.ancestors.include?(Forwardable)

    base.def_delegator :collection, :attribute_definitions, :defined_attributes
    base.def_delegator :attr_values, :[], :attr_value
  end

  # Reconstructs a hash of attiribute titles/values for the current node/edge
  #
  # Example:
  #
  #   node.attributes
  #   => {:site => 'http://www.archive.org', :name => 'The internet archive'}
  #
  # Returns
  #
  #   The attributes hash
  #
  def attributes()
    Hash[*defined_attributes.map do |_, attr|
      [attr.title, attr_value(attr.id)]
    end.flatten]
  end

  def attr_values
    @attr_values ||= {}
  end

  def [](key)
    if attr = attribute_by_title(key)
      attr_value(attr.id)
    else
      Kernel.warn "undefined attribute '#{key}'"
    end
  end

  def []=(key, value)
    attr  = attribute_by_title(key)
    value = attr && attr.coherce(value) || value

    if attr && attr.is_valid?(value)
      attr_values[attr.id] = value
    else
      Kernel.warn "undefined attribute '#{key}'"
    end
  end

private
  def collection
    @collection || []
  end

  def attribute_by_title(key)
    #NOTE: perhaps it is best to just index attributes by title
    _, attribute = *defined_attributes.find { |id, attr| attr.title == key.to_s }
    attribute
  end
end

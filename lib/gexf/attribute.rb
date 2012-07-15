class GEXF::Attribute

  BOOLEAN     = :boolean
  STRING      = :string
  INTEGER     = :integer
  FLOAT       = :float
  ANY_URI     = :anyURI
  LIST_STRING = :liststring
  TYPES       = [ BOOLEAN, STRING, INTEGER, FLOAT, ANY_URI, LIST_STRING]

  DYNAMIC     = :dynamic
  STATIC      = :static
  MODES       = [DYNAMIC, STATIC]

  NODE        = :node
  EDGE        = :edge
  CLASSES     = [NODE, EDGE]

  attr_reader :type, :id, :title, :options, :mode, :attr_class, :default

  def initialize(id, title, opts={})

    attr_class = opts[:class] || NODE
    mode       = opts[:mode]  || STATIC
    type       = opts[:type]  || STRING
    default    = opts[:default]
    options    = opts[:options]
    id         = id.to_s

    @options   = if type == LIST_STRING && options.respond_to?(:split)
                   options.split('|').uniq
                 else
                   Array(options).uniq
                 end


    raise ArgumentError.new "Invalid or missing type: #{type}" if !TYPES.include?(type)
    raise ArgumentError.new "invalid or missing class: #{attr_class}" if !CLASSES.include?(attr_class)
    raise ArgumentError.new "Invalid mode: #{mode}" if !MODES.include?(mode)

    @attr_class = attr_class
    @type       = type
    @id         = id
    @type       = type
    @mode       = mode
    @title      = title.to_s
    self.default=default
  end

  def default=(value)
    raise ArgumentError.new "value value '#{value}' is not included in 'options' list" if value && @options.any? && !@options.include?(value)
    @default=value
  end

  #Note: is this a violation of the "Tell don't ask principle"?
  def coherce(value)
    case @type
    when BOOLEAN
      case value
      when *['1', 'true', 1, true]
        true
      when *['0', 'false', 0, false]
        false
      end
    when STRING, ANY_URI
      value.to_s
    when FLOAT
      value.to_f if value.respond_to?(:to_f)
    when INTEGER
      value.to_i if value.respond_to?(:to_i)

    when LIST_STRING
      Array(value).flatten.map(&:to_s).uniq
    end
  end

  def is_valid?(value)
    if @options.empty?
      true
    else
      value = value.first if value.respond_to?(:first)
      @options.map(&:to_s).include?(value.to_s)
    end
  end

  def to_hash
    optional = {}
    optional[:options] = options.join('|') if options && options.any?

    {:id => id, :title => title, :type => type}.merge(optional)
  end
end

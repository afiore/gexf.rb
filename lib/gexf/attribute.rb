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

  attr_reader :type, :id, :title, :options, :mode, :default, :attr_class

  def initialize(id, title, opts={})

    attr_class = opts[:class] || NODE
    mode       = opts[:mode]  || STATIC
    type       = opts[:type]  || STRING
    default    = opts[:default]
    id         = id.to_s
    @options   = Array(opts[:options]).uniq


    raise ArgumentError.new "Invalid or missing type: #{type}" if !TYPES.include?(type)
    raise ArgumentError.new "invalid or missing class: #{attr_class}" if !CLASSES.include?(attr_class)
    raise ArgumentError.new "Invalid mode: #{mode}" if !MODES.include?(mode)
    raise ArgumentError.new "Default value '#{default}' is not included in 'options' list" if default && @options.any? && !@options.include?(default)

    @attr_class = attr_class
    @type       = type
    @id         = id
    @type       = type
    @mode       = mode
    @title      = title.to_s
    @default    = default
  end

  #Note: is this a violation of the "Tell don't ask principle..."?
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
    optional[:default] = default if default
    optional[:options] = options.join('|') if options

    {:id => id, :title => title}.merge(optional)
  end
end

$LOAD_PATH << File.dirname(__FILE__) + "/gexf/attribute"

module GEXF
  VERSION = '0.0.1'
end

require 'nokogiri'
require 'set'

require 'attribute'
require 'definable'
require 'assignable'
require 'definable'
require 'set_of_sets'
require 'node'
require 'nodeset'
require 'edge'
require 'edgeset'
require 'graph'
require 'xml_serializer'

$LOAD_PATH << File.expand_path('../gexf', __FILE__)

require 'nokogiri'
require 'forwardable'
require 'set'

module GEXF;end

require 'version'
require 'attribute'
require 'attribute/definable'
require 'attribute/assignable'
require 'set_of_sets'
require 'node'
require 'nodeset'
require 'edge'
require 'edgeset'
require 'graph'
require 'xml_serializer'
require 'document'
require 'support'

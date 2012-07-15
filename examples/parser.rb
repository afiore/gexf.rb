#! /usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib/gexf'

require 'gexf'
require 'pry'

filepath = ARGV[0] || 'examples/data/hello-world.gexf'
xml = File.open(filepath, 'r') { |f| f.read }
document = GEXF::Document.new

parser = Nokogiri::XML::SAX::Parser.new(document)
parser.parse(xml)

graph = document.graph
serializer = GEXF::XmlSerializer.new(graph)
puts serializer.serialize!

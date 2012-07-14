#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib/gexf'
require 'gexf'
require 'pry'

xml = File.open('foo.xml', 'r') { |f| f.read }
document = GEXF::Document.new

parser = Nokogiri::XML::SAX::Parser.new(document)
parser.parse(xml)

graph = document.graph
serializer = GEXF::XmlSerializer.new(graph)
puts serializer.serialize!

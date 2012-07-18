#! /usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib/gexf'

require 'gexf'
require 'pry'

filepath = ARGV[0] || 'examples/data/hello-world.gexf'
file = File.open(filepath, 'r')

graph = GEXF(file)
binding.pry
serializer = GEXF::XmlSerializer.new(graph)
puts serializer.serialize!



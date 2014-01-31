#! /usr/bin/env ruby
$: << File.expand_path('../../lib', __FILE__)
require 'gexf'

# Example of using node attribute types, and assigning unique node IDs

data = [  
  { :source => 'a', :target => 'Boston', :lat => 42.35805, :lon => -71.06361, :weight => 2.0},
  { :source => 'b', :target => 'London', :lat => 51.50722, :lon => -0.1275, :weight => 4.3},
  { :source => 'c', :target => 'Mexico City', :lat => 19.43333, :lon => -99.13333, :weight => 1.0},
  { :source => 'd', :target => 'Cape Town', :lat => 33.92527, :lon => -18.42388, :weight => 6.9},
  { :source => 'e', :target => 'Moscow', :lat => 55.75166, :lon => 37.61777, :weight => 4.5},
  { :source => 'f', :target => 'Moscow', :lat => 55.75166, :lon => 37.61777, :weight => 1.5}
]

graph = GEXF::Graph.new

graph.define_node_attribute( :lat, :type => GEXF::Attribute::FLOAT )
graph.define_node_attribute( :lon, :type => GEXF::Attribute::FLOAT )

data.each do |link|

  item_node = graph.create_node( :label => link[:source], :id => link[:source] )

  place_node = graph.create_node( :label => link[:target], :id => link[:target] )
  place_node[:lat] = link[:lat]
  place_node[:lon] = link[:lon]
  
  item_node.connect_to( place_node, { :type => GEXF::Edge::DIRECTED, :weight => link[:weight] } )

end

puts graph.to_xml
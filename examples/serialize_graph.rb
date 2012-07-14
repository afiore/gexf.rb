#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH << File.dirname(File.dirname(__FILE__)) + '/lib/gexf'
require 'gexf'

g = GEXF::Graph.new

g.define_node_attribute(:page_title)
g.define_node_attribute(:stars, :type => GEXF::Attribute::LIST_STRING,
                                :options => [1,2,3,4,5],
                                :default => 3)
g.define_edge_attribute(:foo)
g.create_node label: 'foo', :id => 'node_1'
g.create_node label: 'bar', :id => 'node_2'

g.nodes['node_1'][:page_title] = 'random page stuff'
g.nodes['node_2'][:stars]      = 2
g.nodes['node_2'].create_and_connect_to({label:'baz', id: 'node_3'}, {type: GEXF::Edge::UNDIRECTED })

s = GEXF::XmlSerializer.new(g)
puts s.serialize!

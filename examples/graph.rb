$: << File.expand_path('../../lib', __FILE__)
require 'pry'
require 'gexf'

graph = GEXF::Graph.new

graph.define_node_attribute(:url)
graph.define_node_attribute(:indegree, :type    => GEXF::Attribute::INTEGER)
graph.define_node_attribute(:frog,     :type    => GEXF::Attribute::BOOLEAN,
                                       :default => true)

gephi               = graph.create_node(:label => 'Gephi')
gephi[:url]         = 'http://gephi.org'
gephi[:indegree]    = 1

webatlas            = graph.create_node(:label => 'WebAtlas')
webatlas[:url]      = 'http://webatlas.fr'
webatlas[:indegree] = 2

rtgi                = graph.create_node(:label => 'RTGI')
rtgi[:url]          = 'http://rtgi.fr'
rtgi[:indegree]     = 1

blab                = graph.create_node(:label => 'BarabasiLab')
blab[:url]          = "http://barabasilab.com"
blab[:indegree]     = 1
blab[:frog]         = false

graph.nodes.select { |node| !node[:frog] }.map(&:label)

gephi.connect_to(webatlas)
gephi.connect_to(rtgi)
webatlas.connect_to(gephi)
rtgi.connect_to(webatlas)
gephi.connect_to(blab)

webatlas.incoming_connections.map { |edge| edge.source.label }

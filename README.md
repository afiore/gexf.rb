# Gexf.rb

A Ruby library for generating, parsing, and serializing graphs expressed in the [GEXF](http://gexf.net) format.
Currently, this project implements only a subset of the GEXF specification: the definition of a basic graph topology,
and the association of data attributes to nodes and edges. I will possibly implement the rest of the specification later on
(i.e. dynamics, hyrarchy, and Phylogeny), as I consolidate the code.

## Installation

    gem install gexf

## Usage

The following snippet initializes a GEXF graph, and defines three node attributes:

````ruby
require 'rubygems'
require 'gexf'

graph = GEXF::Graph.new

graph.create_node_attribute(:url)
graph.create_node_attribute(:indegree, :type    => GEXF::Attribute::INTEGER)
graph.create_node_attribute(:frog,     :type    => GEXF::Attribute::BOOLEAN,
                                       :default => true)
````

Attribute values can be associated to nodes or edges by using the same syntax used
to get/set Ruby Hash keys (symbols are automatically converted into strings).

````ruby
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
````

Once associated to a graph, nodes and edges behave as collections,
implementing and exposing most of the methods in Ruby's _Enumerable_ module:


````ruby
graph.nodes.select { |node| !node[:frog] }.map(&:label)
=> 'BarabasiLab'
````

Edges can be created by calling the `graph.create_edges`, or more coincisely, by calling
connect on the source node.

````ruby
gephi.connect_to(webatlas)
gephi.connect_to(rtgi)
webatlas.connect_to(gephi)
rtgi.connect_to(webatlas)
gephi.connect_to(blab)
````

As it is the case for `graph.nodes`, also edges are enumerable:

````ruby
graph.edges.count
=> 5
````

The complete set of edges can be accessed from the main graph object, or fetched
on a single node basis:

````ruby
webatlas.incoming_connections.map { |edge| edge.source.label }
=> ["Gephi", "RTGI"]
````

### Parsing a GEXF document

Gexf.rb provides a basic SAX parser which allows to import GEXF documents into a
graph objects suitable to be queried and manipulated. To parse a GEXF file into a graph, just
call the GEXF helper method (which is a shortcat to `GEXF::Document.parse(file)`)

````ruby
require 'gexf'
require 'open-uri'

file  = File.open('http://gexf.net/data/data.gexf', 'r')
graph = GEXF(file)
file.close

graph.nodes.count
=> 4
````

### Exporting a graph into an XML document

A graph object can be easily serialized to XML by just calling:

````ruby
graph.to_xml
=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gexf xmlns='\"http://www.gexf.net/1.2draft' xmlns....>"
````

Alternatively, one can obtain the same output by instantiating GEXF::XmlSerializer and calling the `serialize!` method.

````ruby
serializer = GEXF::XmlSerializer.new(graph)
serializer.serialize!
````


## Unit tests

Gexf.rb comes with a fairly decent RSpec test suite. The suite can
be run from project directory issuing the following command:

    bundle exec spec -f d spec

# Gexf.rb

A Ruby library for reading, writing, and manipulating graphs expressed in the [GEXF](http://gexf.net) format.
Currently, this project implements only a subset of the GEXF specs: namely, the definition of a basic graph topology,
and the association of data attributes to nodes and edges. I will possibly implement the rest of the specification
(i.e. dynamics, hyrarchy, and Phylogeny) later, as I consolidate the code.

## Installation

    gem install gexf

## Usage

The following snippet generates a GEXF graph programmatically:

    graph = GEXF::Graph.new

    graph.create_node_attribute(:url)
    graph.create_node_attribute(:indegree, :type    => GEXF::Attribute::INTEGER)
    graph.create_node_attribute(:frog,     :type    => GEXF::Attribute::BOOLEAN,
                                           :default => true)

Attribute values can be associated to nodes or edges by using the same syntax used 
to access Ruby Hash keys (symbols are automatically converted into strings).

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

Once associated to a graph, nodes and edges behave as collections,
implementing most of Ruby's `Enumerable` module's methods:

    graph.nodes.select { |node| !node[:frog] }.map(&:label)
    => 'BarabasiLab'

While instances of Graph do also expose a `create_edge` method, `Node#connect_to` is
often more convenient:

    gephi.connect_to(webatlas)
    gephi.connect_to(rtgi)
    webatlas.connect_to(gephi)
    rtgi.connect_to(webatlas)
    gephi.connect_to(blab)

As nodes, edges are also enumerable:

    graph.edges.count
    => 5

The edges collection can be accessed directly from the main graph instance, or
on a per node basis:

    webatlas.incoming_connections.map { |edge| edge.source.label }
    => ["Gephi", "RTGI"]

## Unit tests

Gexf.rb comes with a fairly decent RSpec test suite. The suite can
be run from project directory issuing the following command:

    bundle exec spec -f d spec

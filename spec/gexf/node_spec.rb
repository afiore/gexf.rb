require 'spec_helper'

describe GEXF::Node do

  let(:indegree)              { GEXF::Attribute.new('1', 'indegree', type: GEXF::Attribute::INTEGER) }
  let(:outdegree)             { GEXF::Attribute.new('2', 'outdegree', type: GEXF::Attribute::INTEGER) }

  let(:attribute_definitions) {{ '1' => indegree,
                                 '2' => outdegree }}

  let(:id)                    { 22 }
  let(:idtype)                { GEXF::Graph::STRING }
  let(:collection)            { mock('nodeset', :attribute_definitions => attribute_definitions) }
  let(:edges)                 { mock('edgeset') }
  let(:graph)                 { double('graph', :nodes => collection, :idtype => idtype, :edges => edges) }
  let(:label)                 { 'foo' }
  let(:attributes)            {{ }}
  let(:options)               {{ :label => label, :attributes => attributes }}
  let(:arguments)             { [id, graph, options] }
  let(:node)                  { GEXF::Node.new(*arguments) }

  subject { node }

  it "includes the GEXF::Attribute::Assignable module" do
    subject.class.include?(GEXF::Attribute::Assignable)
  end

  context "when graph :idtype is string" do
    its(:id) { should == id.to_s }
  end

  context "when graph :idtype is integer" do
    let(:idtype) { GEXF::Graph::INTEGER }
    its(:id) { should == id.to_i }
  end

  describe "#label" do
    context "option provided" do
      its(:label) { should == label }
    end
    context "option omitted" do
      let(:options) {{}}
      its(:label) { should == id.to_s }
    end
  end

  describe "attributes" do
    context "when no attributes are defined" do
      let(:attribute_definitions) {{}}
      its(:attributes) { should be_empty }
    end
    context "when no attributes are supplied" do
      its(:attributes) { should == { 'indegree' => nil, 'outdegree' => nil }}
    end
    context "when attributes are supplied" do
      let(:attributes) {{ :outdegree => '24' }}
      its(:attributes) { should == { 'indegree' => nil, 'outdegree' => 24 }}
    end
  end

  describe "#connect_to" do

    let(:edge_opts)  {{ :type => GEXF::Edge::DIRECTED }}
    let(:other_node) { mock('other_node') }
    let(:new_edge)   { mock('new-edge') }

    subject { node.connect_to(other_node, edge_opts) }

    it "adds the target to the nodes collection, creates and returns a new edge" do

      collection.should_receive(:<<).with(other_node)

      graph.should_receive(:create_edge).
            with(node, other_node, edge_opts).
            and_return(new_edge)

      subject.should == new_edge
    end
  end

  describe "#create_and_connect_to" do
    let(:edge_opts)  {{ :type => GEXF::Edge::DIRECTED }}
    let(:node_attrs) {{ :label => 'other node'}}
    let(:new_node)   { mock('new_node') }

    subject { node.create_and_connect_to(node_attrs, edge_opts) }

    it "creates the node, adds it to nodes collection, and returns it" do
      graph.should_receive(:create_node).with(node_attrs).and_return(new_node)
      collection.should_receive(:<<).with(new_node)
      graph.should_receive(:create_edge).with(node, new_node, edge_opts)

      subject.should == new_node
    end
  end

  describe "#connections" do
    subject { node.connections }

    it "delegates to graph.edges[node.id]" do
      edges.should_receive(:[]).with(node.id)
      subject
    end
  end
end

require 'spec_helper'

describe GEXF::Graph do
  let(:edgetype) { nil }
  let(:idtype)   { nil }
  let(:mode)     { nil }
  let(:opts)     {{ :defaultedgetype => edgetype,
                    :idtype   => idtype,
                    :mode     => mode }}

  let(:graph)    { GEXF::Graph.new(opts) }


  describe "default getters" do
    subject { graph }

    context "when params are valid" do
      its(:defaultedgetype)    { should == GEXF::Edge::UNDIRECTED }
      its(:idtype)      { should == GEXF::Graph::STRING }
      its(:mode)        { should == GEXF::Graph::STATIC }
      its(:nodes)       { should be_empty }
      its(:edges)       { should be_empty }
    end

    context "when params are not valid" do
      [:defaultedgetype, :idtype, :mode].each do |param|

        let(param) { :FOO }

        describe "when #{param} is invalid" do
          it "raises an argument error" do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe "#define_node_attribute" do
    let(:attr_type)  { GEXF::Attribute::STRING }
    let(:attr_id)    { nil }
    let(:default)    { 'home sweet home' }
    let(:title)      { 'page-title' }
    let(:attr_opts)  {{ :default => default,
                        :attr_id => attr_id }}


    subject { graph.define_node_attribute(title, attr_opts) }

    it "delegates to @nodes" do

      new_attribute = double('attribute')

      graph.nodes.should_receive(:define_attribute).
                 with('1', title, attr_opts).
                 and_return(new_attribute)

      subject.should == new_attribute
    end
  end

  describe "#define_edge_attribute" do
    let(:attr_type)  { GEXF::Attribute::STRING }
    let(:attr_id)    { nil }
    let(:default)    { 'home sweet home' }
    let(:title)      { 'page-title' }
    let(:attr_opts)  {{ :default => default,
                        :attr_id => attr_id }}


    subject { graph.define_edge_attribute(title, attr_opts) }

    it "delegates to @nodes" do

      new_attribute = double('attribute')

      graph.edges.should_receive(:define_attribute).
                 with('1', title, attr_opts).
                 and_return(new_attribute)

      subject.should == new_attribute
    end
  end

  describe "#create_node" do
    let(:node_id)     { 'node_21' }
    let(:node_opts)   {{ :label => 'my node' }}
    let(:create_opts) { node_opts }

    before(:each) do
      @node = mock('node')
      nodeset = mock('nodeset')

      GEXF::NodeSet.stub(:new).and_return(nodeset)
      nodeset.should_receive(:<<).at_least(:once).with(@node)
    end

    context "when :id is provided" do
      let(:create_opts) { node_opts.merge(:id => node_id) }

      it "uses the id provided to create a node" do
        GEXF::Node.should_receive(:new).
                   with(node_id, graph, node_opts).
                   and_return(@node)

        graph.create_node(create_opts) == @node
      end
    end

    context "when :id is not provided" do
      it "auto-assigns the id using the internal counter" do
        3.times do |n|
          GEXF::Node.should_receive(:new).
                     once.ordered.
                     with((n+1).to_s, graph, node_opts).
                     and_return(@node)
        end

        3.times { graph.create_node(create_opts) }
      end
    end
  end

  describe "#create_edge" do
    let(:edge_label) { 'bar' }
    let(:source_id)  { '2' }
    let(:target_id)  { '32' }
    let(:source)     { mock('source', :id => source_id) }
    let(:target)     { mock('target', :id => target_id) }
    let(:edge_opts)  {{:label => edge_label }}

    subject { graph.create_edge(source, target, edge_opts) }

    before(:each) do
      @edge   = mock('edge')
      edgeset = mock('edgeset')

      GEXF::EdgeSet.stub(:new).and_return(edgeset)
      edgeset.should_receive(:<<).at_least(:once).with(@edge)
    end

    context "when no :id or :type param is provided" do
      it "auto-assigns the edge :id using the internal counter, and the :type using :edgetype" do

        GEXF::Edge.should_receive(:new).
                   with('1', source.id, target.id, edge_opts.merge(:graph => graph,
                                                                   :type  => graph.defaultedgetype)).
                   and_return(@edge)

        subject.should == @edge
      end
    end

    context "when an :id and a :type are provided" do

      let(:edge_id)   { 'myedge-33' }
      let(:edge_opts) {{ :label => edge_label,
                         :id    => edge_id,
                         :type  => GEXF::Edge::DIRECTED }}

      it "passes the params to the Edge constructor" do
        expected_opts = edge_opts.reject {|k,v| k == :id }.merge(:graph => graph)

        GEXF::Edge.should_receive(:new).
                   with(edge_id, source.id, target.id, expected_opts).
                   and_return(@edge)

        subject.should == @edge
      end
    end
  end
end

require 'spec_helper'

describe GEXF::EdgeSet do

  def make_edge(attr={})
    mock('edge', :source_id   => attr[:source_id],
                 :target_id   => attr[:target_id],
                 :directed?   => attr[:type] == GEXF::Edge::DIRECTED,
                 :undirected? => attr[:type] == GEXF::Edge::UNDIRECTED)
  end

  let(:source_id)  { '1' }
  let(:target_id)  { '11' }
  let(:type)       { GEXF::Edge::DIRECTED  }
  let(:attrs)      { { :type => type,
                       :source_id => source_id,
                       :target_id => target_id }}

  let(:arguments) { [] }
  let(:edge)      { make_edge(attrs) }

  let(:edge2)     { make_edge(:type => GEXF::Edge::UNDIRECTED,
                              :source_id => '2',
                              :target_id => '22') }

  let(:edge3)     { make_edge(:type => GEXF::Edge::DIRECTED,
                              :source_id => '3',
                              :target_id => '33') }

  let(:edge4)     { make_edge(:type => GEXF::Edge::DIRECTED,
                              :source_id => '3',
                              :target_id => '22') }


  let(:edgeset)  { GEXF::EdgeSet.new(*arguments) }

  describe "#<<" do
    subject { edgeset << edge }

    context "when edge is directed" do
      it "adds the edge to the @data hash, using the :source_id as key" do
        subject.to_hash.should have_key(edge.source_id)
        subject.to_hash.should_not have_key(edge.target_id)
      end
    end

    context "when edge is undirected" do
      let(:type) { GEXF::Edge::UNDIRECTED }

      it "adds the edge to the data hash, using both :source_id, and the :target_id as keys" do
        subject.to_hash.should have_key(edge.source_id)
        subject.to_hash.should have_key(edge.target_id)
      end
    end
  end

  describe "#count" do
    let(:other_edge)  { make_edge(:type => other_edge_type,
                                  :source_id => '3',
                                  :target_id => '33') }

    subject { edgeset << edge << other_edge }

    context "when adding two directed edges" do
      let(:other_edge_type) { GEXF::Edge::DIRECTED }

      it "creates 2 keys in the hash, returns 2" do
        subject.should have(2).items
        subject.to_hash.keys.should have(2).items
      end
    end

    context "when adding a directed and an undirected edge" do
      let(:other_edge_type) { GEXF::Edge::UNDIRECTED }

      it "creates 3 keys in the hash, returns 2" do
        subject.should have(2).items
        subject.to_hash.keys.should have(3).items
      end
    end
  end

  describe "#map" do
    subject { edgeset << edge << edge2 << edge3 << edge4 }

    it "returns a list of unique edges" do
      subject.map(&:source_id).should == ['1', '2', '3', '3']
      subject.map(&:target_id).should == ['11', '22', '33', '22']
    end

  end

  describe "#select" do
    subject { edgeset << edge << edge2 << edge3 }

    it "selects two directed edges" do
      subject.select(&:directed?).should include(edge, edge3)
    end
    it "selects an undirected edge" do
      subject.select(&:undirected?).should include(edge2)
    end
  end

end


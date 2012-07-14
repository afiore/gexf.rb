require 'spec_helper'

BOOLEAN_GETTERS = %w(directed? undirected? mutual?)

describe GEXF::Edge do

  let(:id)       { 1 }
  let(:type)     { nil }
  let(:source_id)   { 2 }
  let(:target_id)   { 232 }
  let(:graph)    { double('graph', :edges => []) }
  let(:weight)   { nil }
  let(:label)    { 'my-edge' }
  let(:options)  { { :graph => graph, :type => type, :weight => weight, :label => label } }
  let(:arguments){ [id, source_id, target_id, options] }

  subject { GEXF::Edge.new(*arguments) }

  describe "#new" do
    its(:id)         { should == id.to_s }
    its(:source_id)  { should == source_id.to_s }
    its(:target_id)  { should == target_id.to_s }
    its(:weight)     { should == 1.0 }
    its(:label)      { should == label }
    its(:type)       { should == GEXF::Edge::UNDIRECTED }

    [:id, :source_id, :target_id, :graph].each do |param|
      context "when :#{param} is missing" do
        let(param) { nil }

        it "raises an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context "non-positive :weight" do
      let(:weight) { -10 }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "invalid type" do
      let(:type) { :FOOBAR }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  BOOLEAN_GETTERS.each do |method|
    edge_type     = GEXF::Edge.const_get(method[0..-2].upcase.to_sym)
    other_getters = BOOLEAN_GETTERS - [method]

    describe(method) do
      context "when type is :#{edge_type}" do
        let(:type) { edge_type }

        its(method) { should be_true }

        other_getters.each do |other_type|
          its(other_type) { should be_false }
        end
      end
    end
  end
end

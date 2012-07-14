require 'spec_helper'

module FakeClassess
  class NodeSet < Set
    include GEXF::Attribute::Definable
  end
end

describe GEXF::Attribute::Definable do
  let(:node1)     { mock('node', :id => '1' )}
  let(:node2)     { mock('node', :id => '2' )}
  let(:nodeset)   { FakeClassess::NodeSet.new }
  let(:attr_id)   { '22' }
  let(:title)     { 'tags' }
  let(:attr_type) { GEXF::Attribute::LIST_STRING }
  let(:opts)      {{ :type => attr_type }}
  let(:arguments) {[attr_id, title, opts]}

  before do
    nodeset << node1 << node2
  end

  describe "#define_attribute" do
    subject { nodeset.define_attribute(*arguments) }

    it "Instantiates an new GEXF::Attribute" do
      subject.should be_a_kind_of(GEXF::Attribute)
    end
  end

  describe "#attribute_definitions" do

    let(:attribute) { mock('attribute') }

    subject { nodeset }

    before(:each) do
      GEXF::Attribute.should_receive(:new).and_return(attribute)
      nodeset.define_attribute(*arguments)
    end

    its(:attribute_definitions) { should have_key(attr_id) }
    its(:attribute_definitions) { should have_value(attribute) }
    its(:attribute_definitions) { should have(1).item }
  end

  describe "#attributes" do
    let(:nodeattrs)  {{ :foo => 'fooval', :bar => 'barval' }}

    subject { nodeset.attributes }

    before(:each) do
      node1.stub(:attributes).and_return(nil)
      node2.stub(:attributes).and_return(nodeattrs)

      nodeset.define_attribute('1', 'foo')
      nodeset.define_attribute('2', 'bar')
    end

    it "returns a hash of items with attributes" do
      subject.should_not have_key('1')
      subject.should have_key('2')
      subject.should have_value(nodeattrs)
    end
  end
end

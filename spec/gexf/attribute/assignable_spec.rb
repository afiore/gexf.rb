require 'spec_helper'

module FakeClasses
  class MyClass
    include GEXF::Attribute::Assignable

    def initialize(collection, attr_values)
      @collection  = collection
      @attr_values = attr_values
    end
  end
end

describe GEXF::Attribute::Assignable do

  let(:attribute1)  { double('attribute1', :id => '1', :title => "attribute1", :default => nil) }
  let(:attribute2)  { double('attribute2', :id => '2', :title => "attribute2", :default => nil) }
  let(:attribute3)  { double('attribute3', :id => '3', :title => "attribute3", :default => nil) }
  let(:frog)        { GEXF::Attribute.new(4, 'frog', :default => true, :type => GEXF::Attribute::BOOLEAN) }

  let(:attr_values) {{}}

  let(:attributes)   { { '1' => attribute1,
                         '2' => attribute2,
                         '3' => attribute3 } }

  let(:collection)   { double('collection', :attribute_definitions => attributes) }

  subject { FakeClasses::MyClass.new(collection, attr_values) }

  describe "#attributes" do
    context "when graph has no attribute definition" do
      let(:attributes) {{}}
      its(:attributes) { should == attributes }
    end

    context "when graph has attributes" do
      context "node/edge has no values set" do
        it "returns a hash of attributes with nil values" do
          subject.attributes.should == {
            'attribute1' => nil,
            'attribute2' => nil,
            'attribute3' => nil
          }
        end
      end

      context "node/edge has values" do

        let(:attr_values) {{ '1' => 'foo',
                             '2' => 'bar'}}

        it "returns a hash of attributes with non-nil values" do
          subject.attributes.should == {
            'attribute1' => 'foo',
            'attribute2' => 'bar',
            'attribute3' => nil
          }
        end
      end
    end
  end

  describe "#[]" do
    context 'when attribute title does not exist' do
      it "raises a warning, and returns nil" do
        Kernel.should_receive(:warn).with("undefined attribute 'other-attribute'")
        subject['other-attribute'].should be_nil
      end
    end
    context "when node/edge has no attribute values" do
      it "returns nil" do
        Kernel.should_not_receive(:warn)
        subject['attribute1'].should be_nil
      end
    end

    context "when node/edge has a value" do
      let(:attr_values) {{ '1' => 'foo' }}

      it "returns the value" do
        subject[:attribute1].should == 'foo'
      end
    end

    context "when attribute has a default value" do
      let(:attributes) {{ frog.id => frog }}

      it "returns the default value" do
        subject[:frog].should == true
      end
    end
  end

  describe "#[]=" do

    let(:value) { '22' }

    context 'when attribute title does not exist' do
      it "prints a warning, does not set the attribute value" do
        Kernel.should_receive(:warn).with("undefined attribute 'other-attribute'")
        attr_values.should_not_receive(:[]=)
        subject['other-attribute'] = value
      end
    end

    context "when attribute title does exist" do
      it "sets the attribute value" do
        Kernel.should_not_receive(:warn)
        attribute2.should_receive(:coherce).with(value).and_return(value)
        attribute2.should_receive(:is_valid?).with(value).and_return(true)
        attr_values.should_receive(:[]=).with('2', value)
        subject['attribute2'] = value
      end
    end
  end

end

require 'spec_helper'

TRUTHY_INPUTS = [1, '1', true, 'true']
FALSY_INPUTS  = [0, '0', false, 'false']
EMPTY_ARRAY   = []
EMPTY_STRING  = []
OBJECT        = Object.new

describe GEXF::Attribute do

  let(:id)           { 22 }
  let(:type)         { nil }
  let(:mode)         { nil }
  let(:attr_class)   { nil }
  let(:title)        { 'foo' }
  let(:attr_options) { ['foo', 'bar', 'baz'] }
  let(:title)        { 'bar' }
  let(:default)      { 'foo' }

  let(:options)      {{ :mode    => mode,
                        :class   => attr_class,
                        :default => default,
                        :type    => type,
                        :options => attr_options }}

  let(:arguments)    { [id, title, options] }

  subject { GEXF::Attribute.new(*arguments) }

  describe "getter methods" do
    its(:title)      { should == 'bar' }
    its(:type)       { should == GEXF::Attribute::STRING }
    its(:id)         { should == id.to_s }
    its(:options)    { should == attr_options }
    its(:default)    { should == default }
    its(:mode)       { should == GEXF::Attribute::STATIC }
    its(:attr_class) { should == GEXF::Attribute::NODE }

    context "with invalid type" do
      let(:type) { :BANANA }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    {:mode => :FOO, :attr_class => :BANANA}.each do |attr, invalid_value|
      context "when :#{attr} is not valid" do
        let(attr) { invalid_value }

        it "raises an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context "when 'options' do not include 'default' value" do
      let(:default) { :bacon }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "is_valid?" do
    context "when :options is empty/nil" do
      let(:attr_options) { nil }

      it "returns true" do
        subject.is_valid?('whaterver').should be_true
      end
    end

    context "when :options is not empty" do
      context "and :options include input value" do
        it "returns true" do
          subject.is_valid?('foo').should be_true
        end
      end
      context "and :options do not include input value" do
        it "returns false" do
          subject.is_valid?('bacon').should be_false
        end
      end
    end
  end

  describe "coherce" do

    subject { GEXF::Attribute.new(*arguments).coherce(value) }

    context "when attribute type is :BOOLEAN" do
      let(:type) { GEXF::Attribute::BOOLEAN }

      context "Falsy inputs" do
        FALSY_INPUTS.each do |value|
          context "and input value is #{value}" do
            let(:value) { value }
            it { subject.should be_false }
          end
        end
      end
      context "Truty inputs" do
        TRUTHY_INPUTS.each do |value|
          context "and input value is #{value}" do
            let(:value) { value }
            it { subject.should be_true }
          end
        end
      end
      context "other input types" do
        [22, -2, Object.new, [1,2,3], 'hello', :hi].each do |value|
          context "input value is '#{value.inspect}'" do
            let(:value) { value }

            it { subject.should be_nil }
          end
        end
      end
    end

    [GEXF::Attribute::STRING, GEXF::Attribute::ANY_URI].each do |type|
      context "when attribute type is #{type}" do
        let(:type) { type }

        [22, 2.1, Object.new, nil, true, false].each do |value|
          context "and input value is '#{value.inspect}'" do
            let(:value) { value }
            it { should == value.to_s }
          end
        end
      end
    end

    context "when attribute type is :INTEGER" do
      let(:type) { GEXF::Attribute::INTEGER }

      [22, 2.1, nil].each do |value|
        context "and input value is '#{value.inspect}'" do
          let(:value) { value }
          it { should == value.to_i }
        end
      end

      [Object.new, true, false].each do |value|
        context "and input value is '#{value.inspect}'" do
          let(:value) { value }
          it { should be_nil }
        end
      end
    end

    context "when attribute type is :LIST_STRING" do
      let(:type) { GEXF::Attribute::LIST_STRING }

      context "input is nil" do
        let(:value) { nil }

        it { subject.should == [] }
      end

      context "input is not empty" do
        let(:value) { [:foo, :bar, 22] }
        it { subject.should == value.map(&:to_s) }
      end

      context "input contains duplicates" do
        let(:value) { [:foo, :bar, 22, 'foo'] }
        it { subject.should == %w(foo bar 22) }
      end

      context "input contains nested lists" do
        let(:value) { [:foo, :bar, 22, ['foo']] }
        it { subject.should == %w(foo bar 22) }
      end
    end
  end
end

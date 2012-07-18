require 'spec_helper'

describe GEXF::Document do

  let(:filebody) { '...' }
  let(:graph)    { mock('graph') }
  let(:file)     { mock('file', :read => filebody, :close => nil) }

  describe ".parse" do

    subject { GEXF::Document.parse(file) }

    it "instantiates a GEXF::Document, passes it to the sax parser, and calls parse" do
      parser = mock

      Nokogiri::XML::SAX.stub(:new).
                         with(kind_of(GEXF::Document)).
                         and_return(parser)

      parser.stub(:parse).with(file.read)
      GEXF::Document.any_instance.stub(:graph).and_return(graph)

      subject.should eq(graph)
    end
  end
end

require "spec_helper"

def blacklight_config
  OpenStruct.new(:collection_highlight_field => "highlight_field")
end

describe ApplicationHelper do
  
  describe "collection highlight linking" do
    it "params_for_collection_highlight should return the appropriate params" do
      highlight = mock('highlight')
      highlight.stub(:id).and_return("1")
      params = params_for_collection_highlight(highlight)
      params.should be_a(Hash)
      params[:f][:highlight_field].should be_a(Array)
      params[:f][:highlight_field].length.should == 1
      params[:f][:highlight_field].first.should == "highlight_1"
    end
    
    it "should link to the appropriate collection highlight" do
      highlight = mock('highlight')
      highlight.stub(:id).and_return("1")
      highlight.stub(:name_en).and_return("Highlighted Collection")
      link = link_to_collection_highlight(highlight)
      link.should =~ /^<a href=".*highlight_field.*highlight_1">Highlighted Collection<\/a>$/
    end
    
  end
  
  describe "highlight_text" do
    it "should return the normal text of no highlighting exists" do
      doc = {"test_field" => "Test Text"}
      doc.should_receive(:highlight_field).with("test_field").and_return false
      highlight_text(doc, "test_field").should == "Test Text"
    end
  end
  
end
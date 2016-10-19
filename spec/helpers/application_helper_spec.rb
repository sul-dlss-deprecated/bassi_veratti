require "spec_helper"

def blacklight_config
  OpenStruct.new(:collection_highlight_field => "highlight_field")
end

describe ApplicationHelper do
  describe "collection highlight linking" do
    it "params_for_collection_highlight should return the appropriate params" do
      highlight = double('highlight')
      allow(highlight).to receive(:id).and_return("1")
      params = params_for_collection_highlight(highlight)
      expect(params).to be_a(Hash)
      expect(params[:f][:en_highlight_field]).to be_a(Array)
      expect(params[:f][:en_highlight_field].length).to eq(1)
      expect(params[:f][:en_highlight_field].first).to eq("highlight_1")
    end

    it "should link to the appropriate collection highlight" do
      highlight = double('highlight')
      allow(highlight).to receive(:id).and_return("1")
      allow(highlight).to receive(:name_en).and_return("Highlighted Collection")
      allow(highlight).to receive(:name_it).and_return("Highlighted Collection")
      link = link_to_collection_highlight(highlight)
      expect(link).to match(/^<a href=".*highlight_field.*highlight_1">Highlighted Collection<\/a>$/)
    end
  end

  describe "highlight_text" do
    it "should return the normal text of no highlighting exists" do
      doc = { "test_field" => "Test Text" }
      expect(doc).to receive(:highlight_field).with("test_field").and_return false
      expect(highlight_text(doc, "test_field")).to eq("Test Text")
    end
  end
end

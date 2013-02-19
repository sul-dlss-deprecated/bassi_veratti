require "spec_helper"

describe FacetsHelper do
  
  describe "Blacklight overrides" do
    describe "facet_field_names" do
      it "should remove all the appropriate facet field names and replace them with the field including the locale" do
        helper.stub_chain([:blacklight_config, :facet_fields, :keys]).and_return(["en_document_types_ssim", "it_document_types_ssim", "something"])
        helper.send(:facet_field_names).should_not include "it_document_types_ssim"
        helper.send(:facet_field_names).should include "en_document_types_ssim"
      end
    end
  end
  
end
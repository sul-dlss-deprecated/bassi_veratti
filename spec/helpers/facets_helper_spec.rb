describe FacetsHelper do
  describe "Blacklight overrides" do
    describe "should_render_facet?" do
      it "should remove all the appropriate facet field names and replace them with the field including the locale" do
        allow(helper).to receive_message_chain([:blacklight_config, :facet_fields]).and_return("en_document_types_ssim" => double(show: true), "it_document_types_ssim" => double(show: true))

        expect(helper.should_render_facet?(double(name: "it_document_types_ssim", items: [1, 2, 3]))).to be_falsey
        expect(helper.should_render_facet?(double(name: "en_document_types_ssim", items: [1, 2, 3]))).to be_truthy
      end
    end
  end
end

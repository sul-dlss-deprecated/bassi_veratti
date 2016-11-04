describe FacetsHelper do
  describe 'Blacklight overrides' do
    let(:config) do
      bc = Blacklight::Configuration.new
      allow(bc).to receive(:facet_configuration_for_field).with('it_document_types_ssim').and_return double(show: true)
      allow(bc).to receive(:facet_configuration_for_field).with('en_document_types_ssim').and_return double(show: true)
      bc
    end

    before do
      allow(helper).to receive(:blacklight_config).and_return config
      allow(helper).to receive(:blacklight_configuration_context).and_return Blacklight::Configuration::Context.new(helper)
    end

    describe 'should_render_facet?' do
      it 'should remove all the appropriate facet field names and replace them with the field including the locale' do
        expect(helper.should_render_facet?(double(name: 'it_document_types_ssim', items: [1, 2, 3]))).to be_falsey
        expect(helper.should_render_facet?(double(name: 'en_document_types_ssim', items: [1, 2, 3]))).to be_truthy
      end
      it 'should remove all the appropriate facet field names and replace them with the field including the locale' do
        I18n.locale = 'it'
        expect(helper.should_render_facet?(double(name: 'it_document_types_ssim', items: [1, 2, 3]))).to be_truthy
        expect(helper.should_render_facet?(double(name: 'en_document_types_ssim', items: [1, 2, 3]))).to be_falsey
      end
    end
  end
end

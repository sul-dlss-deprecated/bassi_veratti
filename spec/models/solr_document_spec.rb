describe SolrDocument do
  it "should behave like a SolrDocument" do
    doc = SolrDocument.new(:id => "12345")
    expect(doc).to be_a SolrDocument
    expect(doc[:id]).to eq("12345")
    expect(doc).to respond_to :export_formats
  end

  describe "collections" do
    it "should define themselves as such when they have the correct fields" do
      expect(SolrDocument.new(:id => "12345").collection?).to be_falsey
      expect(SolrDocument.new(:id => "12345", :format_ssim => "Collection").collection?).to be_truthy
    end
    describe "collection siblings" do
      it "should memoize the solr request to get the siblings of a collection member" do
        response = { "response" => { "numFound" => 3, "docs" => [{ :id => "1234" }, { :id => "4321" }] } }
        solr = double("solr")
        expect(solr).to receive(:select).with(:params => { :fq => "is_member_of_ssim:\"collection-1\"", :rows => "1000" }).once.and_return(response)
        expect(Blacklight).to receive(:solr).and_return(solr)
        doc = SolrDocument.new(:id => "abc123", :is_member_of_ssim => ["collection-1"])
        5.times do
          doc.collection_siblings
        end
      end
    end
    describe "collection members" do
      it "should define themselves as such when they have the correct fields" do
        expect(SolrDocument.new(:id => "12345").collection_member?).to be_falsey
        expect(SolrDocument.new(:is_member_of_ssim => "collection-1").collection_member?).to be_truthy
      end
      it "should memoize the solr request to get collection memers" do
        response = { "response" => { "numFound" => 3, "docs" => [{ :id => "1234" }, { :id => "4321" }] } }
        solr = double("solr")
        expect(solr).to receive(:select).with(:params => { :fq => "is_member_of_ssim:\"collection-1\"", :rows => "1000" }).once.and_return(response)
        expect(Blacklight).to receive(:solr).and_return(solr)
        doc = SolrDocument.new(:id => "collection-1", :format_ssim => "Collection")
        5.times do
          doc.collection_members
        end
      end
      it "should memoize the solr request to get a collection member's parent collection" do
        response = { "response" => { "numFound" => 1, "docs" => [{ :id => "1234" }] } }
        solr = double("solr")
        expect(solr).to receive(:select).with(:params => { :fq => "id:\"abc123\"" }).once.and_return(response)
        expect(Blacklight).to receive(:solr).and_return(solr)
        doc = SolrDocument.new(:id => "item-1", :is_member_of_ssim => ["abc123"])
        5.times do
          doc.collection
        end
      end

      it "should return nil if the SolrDocument is not a collection" do
        expect(SolrDocument.new(:id => "1235").collection_members).to be nil
      end
    end
    describe "all_collections" do
      it "should memoize the solr request to get all collections" do
        response = { "response" => { "numFound" => 2, "docs" => [{ :id => "1234" }, { :id => "4321" }] } }
        solr = double("solr")
        expect(solr).to receive(:select).with(:params => { :fq => "format_ssim:\"Collection\"", :rows => "10" }).once.and_return(response)
        expect(Blacklight).to receive(:solr).and_return(solr)
        doc = SolrDocument.new
        5.times do
          doc.all_collections
        end
      end
      it "should return an array of solr documents" do
        response = { "response" => { "numFound" => 2, "docs" => [{ :id => "1234" }, { :id => "4321" }] } }
        solr = double("solr")
        expect(solr).to receive(:select).with(:params => { :fq => "format_ssim:\"Collection\"", :rows => "10" }).and_return(response)
        expect(Blacklight).to receive(:solr).and_return(solr)
        docs = SolrDocument.new.all_collections
        expect(docs).to be_a Array
        docs.each do |doc|
          expect(doc).to be_a SolrDocument
          expect(["1234", "4321"]).to include(doc[:id])
        end
      end
    end
  end

  describe "images" do
    before(:all) do
      @images = SolrDocument.new(:image_id_ssm => ["abc123", "cba321"]).images
    end
    it "should point to the test URL" do
      @images.each do |image|
        expect(image).to include BassiVeratti::Application.config.stacks_url
      end
    end
    it "should link to the image identifier field " do
      @images.each do |image|
        expect(image).to match(/abc123|cba321/)
      end
    end
    it "should have the proper default image dimension when no size is specified" do
      @images.each do |image|
        expect(image).to match(/#{SolrDocument.image_dimensions[:default]}/)
      end
    end
    it "should return the requested dimentsion when one is specified" do
      SolrDocument.new(:image_id_ssm => ["abc123", "cba321"]).images(:large).each do |image|
        expect(image).to match(/#{SolrDocument.image_dimensions[:large]}/)
      end
    end
    it "should return [] when the document does not have an image identifier field" do
      expect(SolrDocument.new(:id => "12345").images).to eq([])
    end
    describe "image dimensions" do
      it "should be a hash of configurations" do
        expect(SolrDocument.image_dimensions).to be_a Hash
        expect(SolrDocument.image_dimensions).to have_key :default
      end
    end
  end
end

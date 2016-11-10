describe CatalogController, type: :controller, integration: true do
  let(:params) do
    ActionController::Parameters.new(q: 'Medaglia', controller: 'catalog', action: 'index')
  end

  # note: this actually tests that the indexing logic prepared Solr correctly
  it 'should exclude folder documents where the item is described at the same level (and therefore a duplicate)' do
    result, docs = controller.search_results(params)
    expect(docs.size).to be 2 # if we had the folder objects we would get dups and have 4 results.
  end
end

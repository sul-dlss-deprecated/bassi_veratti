require 'spec_helper'

describe("Search and catalog controller pages", :type => :request, :integration => true) do
  before(:each) do
  end

  it "should show the collection highlights" do
    visit collection_highlights_path
    expect(page).to have_content(@collection1)
    expect(page).to have_content(@collection2)
  end

  it "should show an item detail page" do
    visit catalog_path(:id => 'ref486')
    expect(page).to have_content("Sonetto di Francesca Manzoni [ Pilla], s.a., s.d.")
    expect(page).to have_content("1.0 leaf/leaves")
    expect(page).to have_content("http://purl.stanford.edu/ys098my3414")
    expect(page).to have_content("Other items in this folder (29)")
    expect(page).to have_xpath("//img[contains(@src, \"image/ys098my3414/ys098my3414_001_thumb.jpg\")]") # main image
    expect(page).to have_xpath("//img[contains(@src, \"image/pv196nk4650/pv196nk4650_001_square.jpg\")]") # an "other items" image
  end

  it "should exclude folder documents where the item is described at the same level (and therefore a duplicate)" do
    visit catalog_index_path(:q => "Medaglia")
    expect(page).to have_content("1 - 2 of 2") # if we had the folder objects we would get dups and have 4 results.
  end
end

require 'spec_helper'

describe("Search and catalog controller pages",:type=>:request,:integration=>true) do
  
  before(:each) do

  end
          
  it "should show the collection highlights" do
    visit collection_highlights_path
    page.should have_content(@collection1)
    page.should have_content(@collection2)  
  end
  
  it "should show an item detail page" do
    visit catalog_path(:id=>'ref486')
    page.should have_content("Sonetto di Francesca Manzoni [ Pilla], s.a., s.d.")
    page.should have_content("1.0 leaf/leaves")
    page.should have_content("http://purl.stanford.edu/ys098my3414")
    page.should have_content("Other items in this folder (30)")
    page.should have_xpath("//img[@src=\"https://stacks-test.stanford.edu/image/ys098my3414/ys098my3414_001_thumb.jpg\"]") # main image
    page.should have_xpath("//img[@src=\"https://stacks-test.stanford.edu/image/pv196nk4650/pv196nk4650_001_square.jpg\"]") # an "other items" image
  end
  
end
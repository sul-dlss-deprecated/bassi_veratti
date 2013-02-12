require 'spec_helper'

describe("Search and catalog controller pages",:type=>:request,:integration=>true) do
  
  before(:each) do

  end
          
  it "should show the collection highlights" do
    visit collection_highlights_path
    page.should have_content(@collection1)
    page.should have_content(@collection2)  
  end
  
end
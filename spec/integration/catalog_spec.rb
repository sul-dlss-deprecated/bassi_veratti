require 'spec_helper'

describe("Search Pages",:type=>:request,:integration=>true) do
  
  before(:each) do

  end
    
  it "should show the first two collections on the collections page" do
    visit all_collections_path
    page.should have_content(@collection1)
    page.should have_content(@collection2)  
  end
  
end
require 'spec_helper'

describe("Search and catalog controller pages",:type=>:request,:integration=>true) do
  
  before(:each) do

  end

  it "should show the content inventory page" do
    visit inventory_path
    
  end

end
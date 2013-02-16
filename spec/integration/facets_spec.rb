require 'spec_helper'

describe "Facets",  :type => :request, :integration => true do
  describe "i18n" do
    it "should change the facet label language" do
      visit root_path(:nomap=>true)
      page.should have_content "Personal name"
      page.should_not have_content "Nome personale"
      
      click_link "Italiano"
      page.should have_content "Nome personale"
      page.should_not have_content "Personal name"
      
      click_link "English"
    end
    
    it "should change the document type facet when changing language" do
      visit root_path(:nomap=>true)
      page.should have_content "Document type"
      page.should have_content "Correspondence"
      page.should_not have_content "Categoria di documento"
      page.should_not have_content "Carteggio"
      
      click_link "Italiano"
      page.should have_content "Categoria di documento"
      page.should have_content "Carteggio"
      page.should_not have_content "Document type"
      page.should_not have_content "Correspondence"
      
      click_link "English"
    end
  end
end
describe "Facets", :type => :request, :integration => true do
  describe "i18n" do
    it "should change the facet label language" do
      visit root_path(:nomap => true)
      expect(page).to have_content "Personal name"
      expect(page).not_to have_content "Persone"

      click_link "Italiano"
      expect(page).to have_content "Persone"
      expect(page).not_to have_content "Personal name"

      click_link "English"
    end

    it "should change the document type facet when changing language" do
      visit root_path(:nomap => true)
      expect(page).to have_content "Document type"
      expect(page).to have_content "Correspondence"
      expect(page).not_to have_content "Tipologia documentaria"
      expect(page).not_to have_content "Carteggio"

      click_link "Italiano"
      expect(page).to have_content "Tipologia documentaria"
      expect(page).to have_content "Carteggio"
      expect(page).not_to have_content "Document type"
      expect(page).not_to have_content "Correspondence"

      click_link "English"
    end
  end
end

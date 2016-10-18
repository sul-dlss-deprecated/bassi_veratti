require 'spec_helper'

describe("Inventory and background pages", :type => :request, :integration => true) do
  it "should show the content inventory page" do
    visit inventory_path
    page.should have_content("1. Istrumenti relativi alla famiglia Bassi, 1591-1776")
    page.should have_content("2 Boxes, 63 Folders, 63 Items")
  end

  it "should show the background page" do
    visit background_path
    page.should have_content("Background")
    page.should have_content("When the rearrangement began, there were nine boxes:")
    page.should have_content("Footnotes")
  end
end

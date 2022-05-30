require "helpers/database_helpers"

RSpec.describe "Campaigns Feature", type: :feature do
  before(:each) do
    DatabaseHelpers.clear_table("campaigns")
    DatabaseHelpers.clear_table("users")
  end

  it "signs up user as advertiser and goes to campaign set up page" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    check "advertiser"
    click_button "Save"
    expect(page).to have_content "My Campaigns"
    expect(page).to have_content "Yes"
  end

  it "signs up user as advertiser and adds a campaign" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    check "advertiser"
    click_button "Save"
    expect(page).to have_content "My Campaigns"
    expect(page).to have_content "Yes"

    click_link "Add Campaign"
    expect(page).to have_content "Title"
    expect(page).to have_content "Copy"
  end
end

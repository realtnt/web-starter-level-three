require "helpers/database_helpers"

RSpec.describe "Cat Ads Feature", type: :feature do
  before(:each) do
    DatabaseHelpers.clear_table("cat_ads")
    DatabaseHelpers.clear_table("users")
    DatabaseHelpers.clear_table("sightings")
  end

  it "signs up user and shows profile page" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"
    expect(page).to have_content "Profile"
    expect(page).to have_content "tomjones@gmail.com"
  end

  it "logs in and logs out showing the correct menu" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"
    click_link "Log Out"
    expect(page).to have_content "Log In"
    click_link "Log In"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Password:", with: "1234"
    click_button "Log In"
    expect(page).to have_content "Add Missing Cat Ad"
    click_link "Log Out"
    expect(page).not_to have_content "Add Missing Cat Ad"
    expect(page).to have_content "Log In"
  end

  it "logs in and then goes to edit profile" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    expect(page).to have_content "Add Missing Cat Ad"
    expect(page).to have_content "My Cat Ads"
    click_link "Profile"
    click_link "Edit"
    fill_in "Email:", with: "tomj@gmail.com"
    fill_in "Mobile:", with: "0123456788"
    click_button "Save"
    expect(page).not_to have_content "tomjones@gmail.com"
    expect(page).to have_content "tomj@gmail.com"
    expect(page).not_to have_content "0123456789"
    expect(page).to have_content "0123456788"
  end
end

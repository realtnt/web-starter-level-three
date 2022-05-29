require "helpers/database_helpers"

RSpec.describe "Cat Ads Feature", type: :feature do
  before(:each) do
    DatabaseHelpers.clear_table("cat_ads")
    DatabaseHelpers.clear_table("users")
    DatabaseHelpers.clear_table("sightings")
  end

  it "starts with an empty list of ads" do
    visit "/catboard"
    expect(page).to have_content "There are no ads to show."
  end

  it "adds and lists missing cat ads" do
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
    visit "/catboard"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    expect(page).to have_content "Missing persian"
  end

  it "adds and lists multiple ads" do
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
    visit "/catboard"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing aegean"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing moggie"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    expect(page).to have_content "Missing persian"
    expect(page).to have_content "Missing aegean"
    expect(page).to have_content "Missing moggie"
  end

  it "deletes ads" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing aegean"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing moggie"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"

    find('section[name = "Missing persian"]').click_button "Delete"

    expect(page).to have_content "Missing aegean"
    expect(page).not_to have_content "Missing persian"
    expect(page).to have_content "Missing moggie"
  end

  it "updates ads" do
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
    visit "/catboard"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing aegean"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing moggie"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"

    find('section[name = "Missing persian"]').click_link "Edit"
    fill_in "Title", with: "Missing siamese"
    click_button "Update Cat Ad"

    expect(page).to have_content "Missing siamese"
    expect(page).not_to have_content "Missing persian"
    expect(page).to have_content "Missing aegean"
    expect(page).to have_content "Missing moggie"
  end

  it "shows the ad details when logged in" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    
    find('section[name="Missing persian"]').click_link "Details"

    expect(page).to have_content "Missing persian"
    expect(page).to have_content "Special cat gone missing!"
    expect(page).to have_content "Tom Jones"
    expect(page).to have_content "tomjones@gmail.com"
    expect(page).to have_content "0123456789"
  end

  it "shows the ad details when logged in" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"

    click_link "Log Out"
    
    find('section[name="Missing persian"]').click_link "Details"

    expect(page).to have_content "Missing persian"
    expect(page).to have_content "Special cat gone missing!"
    expect(page).to have_content "Tom Jones"
    expect(page).to have_content "tomjones@gmail.com"
    expect(page).to have_content "0123456789"
    expect(page).not_to have_content "Add Sighting"
  end

  it "shows the add sightings page" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    
    click_link "Log Out"
    click_link "Sign Up"

    fill_in "Name:", with: "Bob Jones"
    fill_in "Email:", with: "bobjones@gmail.com"
    fill_in "Mobile:", with: "0123356789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Find Your Cat"
    find('section[name="Missing persian"]').click_link "Details"
    click_link "Add Sighting"

    expect(page).to have_content "Have you seen this cat? Please give details:"
    expect(page).to have_content "Where?"
    expect(page).to have_content "When?"
    expect(page).to have_content "Any more info?"
  end

  it "adds sightings and shows them in detail page" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    
    click_link "Log Out"
    click_link "Sign Up"

    fill_in "Name:", with: "Bob Jones"
    fill_in "Email:", with: "bobjones@gmail.com"
    fill_in "Mobile:", with: "0123356789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Find Your Cat"
    find('section[name="Missing persian"]').click_link "Details"
    click_link "Add Sighting"

    fill_in "Where?", with: "High St"
    fill_in "When?", with: "01/01/2022"
    fill_in "Any more info?", with: "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"

    click_button "Submit"

    expect(page).to have_content "Missing persian"
    expect(page).to have_content "Special cat gone missing!"
    expect(page).to have_content "tomjones@gmail.com"
    expect(page).to have_content "High St"
    expect(page).to have_content "Sat, 01-Jan-2022"
    expect(page).to have_content "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"
  end

  it "adds sightings and shows them in detail page and deletes them" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    
    click_link "Log Out"
    click_link "Sign Up"

    fill_in "Name:", with: "Bob Jones"
    fill_in "Email:", with: "bobjones@gmail.com"
    fill_in "Mobile:", with: "0123356789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Find Your Cat"
    find('section[name="Missing persian"]').click_link "Details"
    click_link "Add Sighting"

    fill_in "Where?", with: "High St"
    fill_in "When?", with: "01/01/2022"
    fill_in "Any more info?", with: "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"

    click_button "Submit"

    find('div[id="High St"]').click_button "Delete"

    expect(page).to have_content "Missing persian"
    expect(page).to have_content "Special cat gone missing!"
    expect(page).to have_content "tomjones@gmail.com"
    expect(page).not_to have_content "High St"
    expect(page).not_to have_content "Sat, Jan 1st"
    expect(page).not_to have_content "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"
  end

  it "adds sightings and shows them in detail page and edits them" do
    visit "/users/signup"
    fill_in "Name:", with: "Tom Jones"
    fill_in "Email:", with: "tomjones@gmail.com"
    fill_in "Mobile:", with: "0123456789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Add Missing Cat Ad"
    fill_in "Title", with: "Missing persian"
    fill_in "Description", with: "Special cat gone missing!"
    click_button "Add Missing Cat Ad"
    
    click_link "Log Out"
    click_link "Sign Up"

    fill_in "Name:", with: "Bob Jones"
    fill_in "Email:", with: "bobjones@gmail.com"
    fill_in "Mobile:", with: "0123356789"
    fill_in "Password:", with: "1234"
    click_button "Save"

    click_link "Find Your Cat"

    find('section[name="Missing persian"]').click_link "Details"

    click_link "Add Sighting"

    fill_in "Where?", with: "High St"
    fill_in "When?", with: "01/01/2022"
    fill_in "Any more info?", with: "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"

    click_button "Submit"

    find('div[id="High St"]').click_link "Edit"

    fill_in "Where?", with: "Market St"
    fill_in "Any more info?", with: "Yo, it was there man!"

    click_button "Submit"

    expect(page).to have_content "Market St"
    expect(page).to have_content "Yo, it was there man!"
    expect(page).not_to have_content "High St"
    expect(page).not_to have_content "Humpty Dumpty sat on a wall Humpty Dumpty had a great fall"
  end

  it "user tries to access Cat Ad Add page without logging in" do
    visit '/catboard/new'

    expect(page).to have_content "Som'n went wrong!"
  end
end

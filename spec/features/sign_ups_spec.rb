require 'rails_helper'

feature "SignUps", type: :feature do
  it "loads the sign up page", js: true do
    visit new_user_path
    expect(page).to have_content("Sign up")
  end

  it "submits a blank form", js: true do
    visit new_user_path
    expect(page).to have_content("Sign up")

    click_button "Submit"
    expect(page).to have_content("There are issues with the sign up form entries")
  end

  it "submits a valid form", js: true do
    visit new_user_path
    fill_in "Username", with: "test_user"
    fill_in "Email", with: "test_user@example.com"
    fill_in "Password", with: "test_password"
    fill_in "Confirm password", with: "test_password"
    click_button "Submit"
  end
end

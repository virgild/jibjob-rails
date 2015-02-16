require 'rails_helper'

RSpec.describe "UserSignups", type: :request do
  describe "loading signup page" do
    it "loads the signup page" do
      get "/app/users/new?_wallaby=1"
      expect(response).to have_http_status(200)
    end
  end

  describe "submitting the signup page" do
    it "submits the form", js: true do
      visit "/app/users/new?_wallaby=1"
      fill_in "Username", with: "testuser"
      fill_in "Email", with: "testuser@example.com"
      fill_in "Password", with: "testpass"
      fill_in "Confirm password", with: "testpass"
      check "I accept the terms and conditions"

      click_button "Submit"
      expect(page).to have_content "Resumes"
    end
  end
end

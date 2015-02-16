require 'rails_helper'

RSpec.describe "UserSignups", type: :request do
  describe "GET /app/users/new" do
    it "works! (now write some real specs)" do
      get "/app/users/new?_wallaby=1"
      expect(response).to have_http_status(200)
    end

    it "works with Javascript", js: true do
      visit "/app/users/new?_wallaby=1"
      expect(page).to be_successful

      fill_in "Username", with: "testuser"
      fill_in "Email", with: "testuser@example.com"
      fill_in "Password", with: "testpass"
      fill_in "Confirm password", with: "testpass"
      check "I accept the terms and conditions"

      click_button "Submit"
    end
  end
end

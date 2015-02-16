require 'rails_helper'

RSpec.describe "UserSignups", type: :request do
  describe "loading signup page" do
    it "loads the signup page" do
      get "/app/users/new?_wallaby=1"
      expect(response).to have_http_status(200)
    end
  end

  describe "after submitting the signup page", js: true do
    before :each do
      visit "/app/users/new?_wallaby=1"
      fill_in "Username", with: "testuser"
      fill_in "Email", with: "testuser@example.com"
      fill_in "Password", with: "testpass"
      fill_in "Confirm password", with: "testpass"
      check "I accept the terms and conditions"

      click_button "Submit"
    end

    it "goes to resumes page" do
      expect(page).to have_content "Resumes"
    end

    context "it created the user" do
      let(:user) { User.where(username: 'testuser').first }

      example "the user exists" do
        expect(user).to_not be_nil
      end

      example "the user has a timezone" do
        expect(user.timezone).to_not be_blank
      end
    end
  end
end

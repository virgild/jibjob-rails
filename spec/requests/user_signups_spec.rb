require 'rails_helper'

RSpec.describe "UserSignups", type: :request, js: true do
  fixtures :all

  before :each do
    visit "/app/users/new"
    fill_in "Username", with: "testuser"
    fill_in "E-mail", with: "testuser@example.com"
    fill_in "Password", with: "testpass"
    fill_in "Confirm password", with: "testpass"
    check "I accept the Terms of service"

    click_button "Submit"
  end

  context "after submitting the form" do
    let(:user) { User.where(username: 'testuser').first }

    it "goes to resumes page" do
      expect(page).to have_content "Resumes"
    end

    it "creates the user" do
      expect(user).to_not be_nil
    end

    it "creates a user with a timezone", no_travis: true do
      expect(user.timezone).to_not be_blank
    end

    context "checking the initial page" do
      it "has data-user-id" do
        data_user_id = page.find('body')['data-user-id']
        expect(data_user_id).to_not be_blank
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Login", type: :request, js: true do
  fixtures :all

  example "log in" do
    visit "/app/login"
    fill_in "username", with: "appleseed"
    fill_in "password", with: "testpass"
    click_button "Submit"

    expect(page).to have_content "Resumes"
  end
end

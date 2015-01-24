require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  test "show sign up page" do
    get "/users/new"
    assert_response :success
  end

  test "load sign up page" do
    Capybara.current_driver = Capybara.javascript_driver
    visit "/users/new"

    click_button "Submit"
  end
end

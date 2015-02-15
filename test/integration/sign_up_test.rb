require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "show sign up page" do
    get "/app/users/new?_wallaby=1"
    assert_response :success
  end

  test "load sign up page" do
    Capybara.current_driver = Capybara.javascript_driver
    visit "/app/users/new?_wallaby=1"

    click_button "Submit"
  end
end

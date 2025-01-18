module AuthenticationHelper
  def login_as_test_user
    user = User.create!(email_address: "tester@testing.com", password: "password")
    visit new_session_path
    fill_in "Enter your email address", with: "tester@testing.com"
    fill_in "Enter your password", with: "password"
    click_button "Sign in"
    user
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :system
end

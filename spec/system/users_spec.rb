require 'rails_helper'

RSpec.describe 'User Signup', type: :system do
  before do
    driven_by(:rack_test)
    User.create!(email_address: "existing_user@example.com", password: "password")
  end

  it 'displays an error when signing up with an already registered email' do
    visit new_user_path
    fill_in "Email", with: "existing_user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign Up"

    expect(page).to have_current_path(new_user_path)
    expect(page).to have_content("This email is already registered.")
  end
end

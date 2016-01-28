require 'spec_helper'

feature 'User resets password' do 
  scenario 'user successfully resets password' do 
    user = Fabricate(:user, password: "old_password")
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link("Reset My Password")

    fill_in "New Password",     with: "new_password"
    fill_in "Confirm Password", with: "new_password"
    click_button "Update Password"

    fill_in "Email", with: user.email
    fill_in "Password",      with: "new_password"
    click_button "Sign In"

    expect(page).to have_content("Welcome, #{user.name}")
    clear_email
  end
end
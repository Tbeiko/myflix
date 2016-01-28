require 'spec_helper'

feature "User invites friend" do 
  scenario "User successfully invites friend and invitation is accepted" do 
    joe = Fabricate(:user)
    sign_in(joe)

    create_invitation("Tim Baguette", "tim@baguette.com", "Hey, check out MyFlix, it's better than paninis")
    sign_out

    accepts_invitation("tim@baguette.com")

    sign_in_thru_form("tim@baguette.com", "password")

    verify_if_following(joe.name)
    sign_out

    sign_in(joe)
    verify_if_following("Tim Baguette")

    clear_email
  end

  def create_invitation(name, email, message)
    visit new_invitation_path
    fill_in "Friend's name", with: name
    fill_in "Freind's Email Address", with: email
    fill_in "Message", with: message
    click_button "Send Invitation"
  end

  def accepts_invitation(user_email)
    open_email user_email
    current_email.click_link "Accept this invitation"
    # Link redirects to the register path
    fill_in "Password", with: "password"
    click_button "Register"
  end

  def sign_in_thru_form(username, password)
    fill_in "Email", with: username
    fill_in "Password",      with: password
    click_button "Sign In"
  end

  def verify_if_following(user)
    click_link "People"
    expect(page).to have_content user
  end
end
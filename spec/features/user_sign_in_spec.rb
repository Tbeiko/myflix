require 'spec_helper'

feature "user signs in" do 
  scenario "with valid credentials" do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content(user.name)
  end
end
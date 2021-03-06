require 'rails_helper'

RSpec.describe "As a default user" do
  it "cannot access certain paths" do
    user = User.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123")

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'

    expect(page).to have_content("Logged in as Andy Dwyer")

    visit '/merchant'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/admin'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end

require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "cannot access certain paths" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
    employee = meg.users.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'

    expect(page).to have_content("Logged in as Andy Dwyer")

    visit '/admin'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/merchant/orders/1'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end

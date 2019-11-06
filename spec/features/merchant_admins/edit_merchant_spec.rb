require 'rails_helper'

RSpec.describe 'As a merchant admin', type: :feature do
  it 'can edit a merchant' do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: 80203)
    @admin = @mike.users.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'

    visit "/merchants/#{@mike.id}"

    click_link 'Update Merchant'

    expect(current_path).to eq("/merchants/#{@mike.id}/edit")

    fill_in 'City', with: 'Orlando'

    click_button 'Update Merchant'

    expect(current_path).to eq("/merchants/#{@mike.id}")

    within '.address' do
      expect(page).to have_content('Orlando')
      expect(page).to_not have_content('Denver')
    end
  end

  it 'must fill all fields to edit a merchant' do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: 80203)
    @admin = @mike.users.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'

    visit "/merchants/#{@mike.id}/edit"

    fill_in 'City', with: ''

    click_button 'Update Merchant'

    expect(current_path).to eq("/merchants/#{@mike.id}")

    expect(page).to have_content("City can't be blank")
  end
end

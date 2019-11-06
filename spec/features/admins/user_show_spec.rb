require 'rails_helper'

RSpec.describe 'Admin User Show Page', type: :feature do
  before :each do
    @user = User.create!(name: "Andy Dwyer", email: "user@gmail.com", password: "password", password_confirmation: "password")
    @address_1 = @user.addresses.create!(nickname: 'Work', street: "478 Hanover Blvd", city: "Denver", state: "CO", zip: 80128)
    @user.orders.create!(address_id: @address_1.id)
    @admin = User.create!(name: "Ron Swanson", email: "admin@gmail.com", password: "password", password_confirmation: "password", role: 3)

    visit '/login'

    fill_in :email, with: 'admin@gmail.com'
    fill_in :password, with: 'password'

    click_button 'Login'
  end

  it 'shows all user info but no edit link' do
    visit "/admin/users/#{@user.id}"

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
    end

    expect(page).to_not have_link('Edit Your Info')
    expect(page).to_not have_link('Change Your Password')
  end

  it 'cannot access a user show page for a nonexistent user' do
    visit '/admin/users/13251'

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end

  it 'can click a link to visit the user orders index' do
    visit "/admin/users/#{@user.id}"
    click_link('Your Orders')

    expect(current_path).to eq("/admin/users/#{@user.id}/orders")
  end
end

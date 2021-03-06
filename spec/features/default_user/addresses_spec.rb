require 'rails_helper'

RSpec.describe 'As a default user', type: :feature do
  before :each do
    @user = User.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    @address_2 = @user.addresses.create!(nickname: 'Work', street: "478 Hanover Blvd", city: "Denver", state: "CO", zip: 80128)
    @address_3 = @user.addresses.create!(nickname: 'Mom\'s', street: "101 Sixma Ave", city: "Deltona", state: "FL", zip: 32738)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'

    visit '/profile'
  end

  it 'can edit an address' do
    within "#address-#{@address_2.id}" do
      click_link 'Edit'
    end

    expect(current_path).to eq("/profile/addresses/#{@address_2.id}/edit")

    expect(page).to have_selector("input[value='Work']")
    expect(page).to have_selector("input[value='478 Hanover Blvd']")
    expect(page).to have_selector("input[value='Denver']")
    expect(page).to have_selector("input[value='CO']")
    expect(page).to have_selector("input[value='80128']")

    fill_in 'Nickname', with: 'Rental'
    fill_in 'Street', with: '8813 Taylor Rd'
    fill_in 'City', with: 'Harvey'
    fill_in 'State', with: 'IL'
    fill_in 'Zip', with: 60426

    click_button 'Update Address'

    expect(current_path).to eq('/profile')

    within "#address-#{@address_2.id}" do
      expect(page).to have_content('Rental')
      expect(page).to have_content('8813 Taylor Rd')
      expect(page).to have_content('Harvey')
      expect(page).to have_content('IL')
      expect(page).to have_content(60426)
    end

    expect(page).to_not have_content('Work')
    expect(page).to_not have_content('478 Hanover Blvd')
    expect(page).to_not have_content(80128)
  end

  it 'cannot edit an address if it has been on a shipped order' do
    Order.create(user_id: @user.id, address_id: @address_2.id, status: 2)

    visit "/profile/addresses/#{@address_2.id}/edit"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("Addresses with orders that have been shipped cannot be edited or deleted")
  end

  it 'shows flash messages when fields are blank in address edit' do
    within "#address-#{@address_2.id}" do
      click_link 'Edit'
    end

    fill_in 'Nickname', with: ''
    fill_in 'Street', with: ''
    fill_in 'City', with: ''
    fill_in 'State', with: ''
    fill_in 'Zip', with: ''

    click_button 'Update Address'

    expect(current_path).to eq("/profile/addresses/#{@address_2.id}")

    expect(page).to have_content("Nickname can't be blank")
    expect(page).to have_content("Street can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
  end

  it 'can delete an address' do
    within "#address-#{@address_3.id}" do
      click_link 'Delete'
    end

    expect(current_path).to eq('/profile')

    expect(page).to_not have_css("#address-#{@address_3.id}")
    expect(page).to_not have_content('101 Sixma Ave')
    expect(page).to_not have_content('Deltona')
    expect(page).to_not have_content('FL')
    expect(page).to_not have_content(32738)
  end

  it 'can create a new address' do
    click_link 'Add New Address'

    expect(current_path).to eq('/profile/addresses/new')

    fill_in 'Nickname', with: 'Rental'
    fill_in 'Street', with: '8813 Taylor Rd'
    fill_in 'City', with: 'Harvey'
    fill_in 'State', with: 'IL'
    fill_in 'Zip', with: 60426

    click_button 'Create Address'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Rental')
    expect(page).to have_content('8813 Taylor Rd')
    expect(page).to have_content('Harvey')
    expect(page).to have_content('IL')
    expect(page).to have_content(60426)
  end

  it 'previously entered info persists through error during address creation' do
    click_link 'Add New Address'

    fill_in 'Nickname', with: 'Rental'
    fill_in 'City', with: 'Harvey'

    click_button 'Create Address'

    expect(current_path).to eq('/profile/addresses')

    expect(page).to have_content("Street can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")

    expect(page).to have_selector("input[value='Rental']")
    expect(page).to have_selector("input[value='Harvey']")
  end

  it 'shows shipping address on order show page' do
    order = Order.create(user_id: @user.id, address_id: @address_2.id, status: 2)

    visit "/profile/orders/#{order.id}"

    expect(page).to have_content('Shipping Address')
    expect(page).to have_content('478 Hanover Blvd')
    expect(page).to have_content('Denver')
    expect(page).to have_content('CO')
    expect(page).to have_content('80128')
  end

  it 'can use change address link from order show page if order has not shipped' do
    order = Order.create(user_id: @user.id, address_id: @address_2.id)

    visit "/profile/orders/#{order.id}"

    click_link 'Change Address'

    expect(current_path).to eq("/profile/addresses/#{@address_2.id}/edit")
  end

  it 'does not show change address link on order show page if order has shipped' do
    order = Order.create(user_id: @user.id, address_id: @address_2.id, status: 2)

    visit "/profile/orders/#{order.id}"

    expect(page).to_not have_link('Change Address')
  end
end

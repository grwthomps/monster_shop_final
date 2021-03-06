require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @user = User.create!(name: "Kay Russell", email: "test@gmail.com", password: "password123", password_confirmation: "password123")

      visit "/login"
      fill_in :email, with: "test@gmail.com"
      fill_in :password, with: "password123"
      click_button "Login"

      visit "/items/#{@paper.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@paper.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@tire.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add Item to Cart"
    end

    # it 'cannot create an order without items', js: true do
    #   page.evaluate_script('window.history.back()')
    #
    #   click_on 'Checkout'
    #
    #   expect(current_path).to eq('/items')
    #   expect(page).to have_content("Please add something to your cart to place an order")
    # end

    it 'allows user to choose shipping address' do
      @address_2 = @user.addresses.create!(nickname: 'Work', street: "478 Hanover Blvd", city: "Denver", state: "CO", zip: 80128)
      @address_3 = @user.addresses.create!(nickname: 'Rental', street: "101 Sixma Ave", city: "Deltona", state: "FL", zip: 32738)

      visit '/profile/orders/new'

      expect(page).to have_content('Select Shipping Address')

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.nickname)
        expect(page).to have_content(@address_2.street)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        expect(page).to have_link('Ship to this Address')
      end

      within "#address-#{@address_3.id}" do
        expect(page).to have_content(@address_3.nickname)
        expect(page).to have_content(@address_3.street)
        expect(page).to have_content(@address_3.city)
        expect(page).to have_content(@address_3.state)
        expect(page).to have_content(@address_3.zip)
        click_link 'Ship to this Address'
      end

      expect(current_path).to eq('/profile/orders')

      expect(page).to have_content("Your order has been successfully created!")

      expect(Order.last.address).to eq(@address_3)
    end

    it 'cannot create order without an address' do
      visit '/profile/orders/new'

      expect(page).to have_content("You must add an address prior to placing an order.")
      expect(page).to have_link('add an address')

      expect(page).to_not have_link('Ship to this Address')
    end
  end
end

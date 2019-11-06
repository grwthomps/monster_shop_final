require 'rails_helper'

RSpec.describe 'As a default user' do
  before :each do
    @user = User.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    @address_2 = @user.addresses.create!(nickname: 'Work', street: "478 Hanover Blvd", city: "Denver", state: "CO", zip: 80128)
    @address_3 = @user.addresses.create!(nickname: 'Mom\'s', street: "101 Sixma Ave", city: "Deltona", state: "FL", zip: 32738)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it 'can see all profile data expect password' do
    visit '/profile'

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
    end
  end

  it 'can prepopulate form to update profile info' do
    visit '/profile'

    click_link 'Edit Your Info'

    expect(current_path).to eq('/profile/edit')

    expect(page).to have_selector("input[value='Andy Dwyer']")
    expect(page).to have_selector("input[value='test@gmail.com']")
  end

  it 'can click a button to edit profile data' do
    visit '/profile/edit'

    fill_in :name, with: 'Billy Bob'
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('You have succesfully updated your information!')

    within '.profile-info' do
      expect(page).to have_content('Billy Bob')
      expect(page).to have_content('billy.bob@gmail.com')
    end
  end

  it 'sees flash messages if fields are blank' do
    visit '/profile/edit'

    fill_in :name, with: ''
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Name can't be blank")
  end


  it 'can click a button to update password' do
    visit '/profile'

    click_link 'Change Your Password'

    expect(current_path).to eq('/profile/edit')

    fill_in :password, with: 'gmoneyisgreat'
    fill_in :password_confirmation, with: 'gmoneyisgreat'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('You have successfully updated your password!')
  end

  it 'cannot change password if password field is blank' do
    visit '/profile/edit?info=false'

    fill_in :password, with: ''
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Please fill in both password fields')

    expect(page).to have_field :password
    expect(page).to have_field :password_confirmation
  end

  it "cannot change password if both fields are filled in but don't match" do
    visit '/profile/edit?info=false'

    fill_in :password, with: 'gmoneyiswack'
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  it "shows a link to orders if user has orders" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    order_1 = Order.create!(user_id: @user.id, address_id: @address_2.id)
    order_1.item_orders.create!(item_id: tire.id, price: tire.price, quantity: 2)

    visit '/profile'

    click_link 'Your Orders'

    expect(current_path).to eq('/profile/orders')
  end

  it "does't have link to orders if user doesn't have any orders" do
    visit '/profile'

    expect(page).to_not have_link('Your Orders')
  end

  it 'shows all currently saved addresses' do
    visit '/profile'

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname)
      expect(page).to have_content(@address_2.street)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zip)
    end

    within "#address-#{@address_3.id}" do
      expect(page).to have_content(@address_3.nickname)
      expect(page).to have_content(@address_3.street)
      expect(page).to have_content(@address_3.city)
      expect(page).to have_content(@address_3.state)
      expect(page).to have_content(@address_3.zip)
    end
  end

  it 'shows links to edit and delete each address' do
    visit '/profile'

    within "#address-#{@address_2.id}" do
      expect(page).to have_link('Edit')
      expect(page).to have_link('Delete')
    end

    within "#address-#{@address_3.id}" do
      expect(page).to have_link('Edit')
      expect(page).to have_link('Delete')
    end
  end

  it 'does not show links to edit or delete addresses that have shipped orders' do
    Order.create(user_id: @user.id, address_id: @address_2.id, status: 2)

    visit '/profile'

    within "#address-#{@address_2.id}" do
      expect(page).to_not have_link('Edit')
      expect(page).to_not have_link('Delete')
    end
  end

  it 'shows a link to add a new address' do
    visit '/profile'

    expect(page).to have_link('Add New Address')
  end
end

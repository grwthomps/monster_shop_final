require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it {should validate_presence_of :nickname}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}

    it { should validate_numericality_of(:zip).only_integer }
    it { should validate_length_of(:zip).is_equal_to(5) }
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'instance methods' do
    it 'can check for shipped orders with current address' do
      user = User.create!(name: "Andy Dwyer", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      address = user.addresses.create!(nickname: 'Work', street: "478 Hanover Blvd", city: "Denver", state: "CO", zip: 80128)

      expect(address.no_shipped_orders?).to eq(true)

      order = Order.create!(user_id: user.id, address_id: address.id, status: 2)

      expect(address.no_shipped_orders?).to eq(false)
    end
  end
end

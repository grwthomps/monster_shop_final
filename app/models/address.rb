class Address < ApplicationRecord
  validates_presence_of :nickname, :street, :city, :state, :zip
  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5

  belongs_to :user
  has_many :orders

  def any_orders?
    orders.any?
  end

  def no_shipped_orders?
    orders.find_by(status: "shipped").nil?
  end
end

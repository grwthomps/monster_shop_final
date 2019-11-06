class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :nickname
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
  end
end

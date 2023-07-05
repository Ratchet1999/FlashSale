class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.timestamps
    end
  end
end

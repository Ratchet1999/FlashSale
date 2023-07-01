class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :session_id
      t.string :payment_intent
      t.string :currency
      t.integer :status
      t.integer :total_amount_in_cents
      
      t.timestamps
    end
  end
end

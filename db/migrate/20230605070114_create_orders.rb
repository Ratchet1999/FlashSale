class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, foreign_key: true
      t.datetime :order_at
      t.integer :total_in_cents, default: 0
      t.integer :tax_in_cents, default: 0
      t.integer :discount_price_in_cents, default: 0
      t.integer :loyality_discount_in_cents, default: 0
      t.integer :net_in_cents, default: 0
      t.integer :status
      t.timestamps
    end
  end
end

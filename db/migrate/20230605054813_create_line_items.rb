class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :deal, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity
      t.integer :price_in_cents
      t.integer :discount_price_in_cents
      t.integer :tax_in_cents
      t.integer :total_in_cents
      t.integer :total_discount_price_in_cents
      t.integer :net_in_cents
      t.timestamps
    end
  end
end

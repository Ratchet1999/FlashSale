class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.string :description
      t.integer :price_in_cents
      t.integer :discount_price_in_cents
      t.integer :quantity, default: 0
      t.datetime :publish_at
      t.datetime :published_at
      t.boolean :publishable, default: false
      t.decimal :deals_tax, precision: 8, scale: 2

      t.timestamps
    end
  end
end

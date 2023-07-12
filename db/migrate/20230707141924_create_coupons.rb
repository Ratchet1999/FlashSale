class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :currency
      t.integer :coupon_type
      t.integer :value, default: 0
      t.integer :status, default: 0
      t.integer :redeem_count, default: 0

      t.timestamps
    end
  end
end

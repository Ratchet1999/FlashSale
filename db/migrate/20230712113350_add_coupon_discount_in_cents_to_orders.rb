class AddCouponDiscountInCentsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :coupon_discount_in_cents, :integer
  end
end

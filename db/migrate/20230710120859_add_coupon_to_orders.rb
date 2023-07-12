class AddCouponToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :coupon
  end
end

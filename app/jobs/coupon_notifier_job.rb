class CouponNotifierJob < ApplicationJob
  def perform
    Coupon.active.each do |coupon|
      User.active.each do |user|
        user.coupons << coupon
        CouponMailer.send_coupon(user, coupon).deliver_later
      end
    end
  end
end

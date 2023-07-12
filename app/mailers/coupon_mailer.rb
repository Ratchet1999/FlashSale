class CouponMailer < ApplicationMailer
  default from: 'FlashDeals'

  def send_coupon(user, coupon)
    @user = user
    @coupon = coupon
    mail to: user.email, subject: 'FlashDeal Daily Coupon'
  end
end

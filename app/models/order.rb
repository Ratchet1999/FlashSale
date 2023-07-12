class Order < ApplicationRecord
  enum :status, { in_progress: 0, placed: 1, delivered: 2, cancelled: 3, wishlist: 4 }
  
  belongs_to :user
  belongs_to :address, optional: true
  has_many :payments
  has_many :refunds
  has_many :line_items, dependent: :destroy, after_add: :add_to_cart, after_remove: :remove_from_cart
  has_many :deals, through: :line_items
  
  scope :placed_orders, ->{ includes(:address, :payments).where(status: 'placed').where(payments: { status: 'successful' }) }
  scope :deal_exists, ->(deal_id){ joins(:deals).where(deals: { id: deal_id }) }
  
  def apply_coupon(coupon)
    coupon.increment!(:redeem_count)
    self.coupon_id = coupon.id
    self.coupon_discount_in_cents = coupon.flat? ? convert_from_currency(convert_to_currency(coupon.value_in_cents, coupon.currency)) : net_in_cents * coupon.value * 0.01
    self.net_in_cents = discount_price_in_cents + tax_in_cents - loyality_discount_in_cents - coupon_discount_in_cents
    save
  end

  def convert_from_currency(price)
    price * Currency.current_rate[User.find_by(id: user_id).currency_preference].to_f
  end

  def cancel_order(refund)
    transaction do
      cancelled!
      refunds.create(refund_id: refund.id, status: 'successful', currency: refund.currency, total_amount_in_cents: refund.amount)
    end
    OrderMailer.with(order: self, refund_id: refund.id).cancelled.deliver_later
  end

  def add_to_cart(line_item)
    coupon = Coupon.find_by(id: coupon_id)
    self.total_in_cents += line_item.price_in_cents
    self.tax_in_cents += line_item.tax_in_cents
    self.discount_price_in_cents += line_item.total_discount_price_in_cents
    self.loyality_discount_in_cents = calculate_loyality_bonus
    self.coupon_discount_in_cents = (discount_price_in_cents + tax_in_cents - loyality_discount_in_cents) * coupon.value * 0.01 if coupon&.percent?
    self.net_in_cents = discount_price_in_cents + tax_in_cents - loyality_discount_in_cents - coupon_discount_in_cents
    save
  end

  def remove_from_cart(line_item)
    coupon = Coupon.find_by(id: coupon_id)
    self.total_in_cents -= line_item.price_in_cents
    self.tax_in_cents -= line_item.tax_in_cents
    self.discount_price_in_cents -= line_item.total_discount_price_in_cents
    self.loyality_discount_in_cents = calculate_loyality_bonus
    self.coupon_discount_in_cents = (discount_price_in_cents + tax_in_cents - loyality_discount_in_cents) * coupon.value * 0.01 if coupon&.percent?
    if line_items.size.zero?
      self.coupon_id = nil
      self.coupon_discount_in_cents = 0
    end
    self.net_in_cents = discount_price_in_cents + tax_in_cents - loyality_discount_in_cents - coupon_discount_in_cents
    save
  end

  def discount_price
    discount_price_in_cents * 0.01
  end

  def order_total
    total_in_cents * 0.01
  end

  def total_tax
    tax_in_cents * 0.01
  end

  def net_total
    net_in_cents * 0.01
  end

  def loyality_bonus
    loyality_discount_in_cents * 0.01
  end

  def coupon_discount
    coupon_discount_in_cents * 0.01
  end

  def calculate_loyality_bonus
    total = self.discount_price_in_cents + self.tax_in_cents
    order_count = user.orders.size

    if order_count > 3
      0.05 * total
    elsif order_count > 2
      0.02 * total
    elsif order_count > 1
      0.01 * total
    else
      0
    end
  end
end

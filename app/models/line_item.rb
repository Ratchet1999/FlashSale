class LineItem < ApplicationRecord
  belongs_to :deal
  belongs_to :order

  before_save :calculate_net_price

  def calculate_net_price
    deal = Deal.find(self.deal_id)
    self.total_in_cents = price_in_cents * quantity
    self.total_discount_price_in_cents = discount_price_in_cents * quantity
    self.tax_in_cents = deal.tax_percentage * total_discount_price
    self.net_in_cents = total_discount_price_in_cents + tax_in_cents
  end

  def price
    price_in_cents * 0.01
  end

  def discount_price
    discount_price_in_cents * 0.01
  end

  def total_discount_price
    total_discount_price_in_cents * 0.01
  end

  def total_price
    total_in_cents * 0.01 
  end

  def tax_on_deal
    tax_in_cents * 0.01
  end

  def net_price
    net_in_cents * 0.01
  end
end

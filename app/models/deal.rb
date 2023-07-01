class Deal < ApplicationRecord
  has_many :deal_images, dependent: :destroy
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items

  accepts_nested_attributes_for :deal_images, allow_destroy: true, reject_if: proc { |attributes| attributes[:image].blank? }

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :publish_at, presence: true

  validates :scheduled_deals_count, numericality: { less_than: MAXIMUM_DEALS_TO_SCHEDULE , message: "No more than 2 deals can be published in one day" }, on: :create

  validates :discount_price_in_cents, numericality: { less_than_equal_to: :price_in_cents }

  with_options on: :publish do
    validates :quantity, numericality: { greater_than: MINIMUM_DEAL_QUANTITY, message: ' should be greater than 10' }
    validates :images_count, numericality: { greater_than_or_equal_to: MINIMUM_DEAL_IMAGE , message: 'should be greater than or equal to 2' }
    validates :tax_percentage, numericality: { in: MINIMUM_TAX_RATE..MAXIMUM_TAX_RATE }, allow_blank: true
  end

  validate :valid_publish_at, on: :update

  scope :live, ->{ where(publishable: true).where.not(published_at: nil) }
  scope :expired, ->{ where(publishable: false).where.not(published_at: nil) }
  scope :publishable_on, ->(date) { where(publish_at: date) }
  scope :to_publish, ->{ where('DATE(publish_at) = ?', Date.current).where(published_at: nil).where(publishable: true) }
  scope :to_unpublish, ->{ where('DATE(publish_at) = ?', Date.yesterday).where.not(published_at: nil).where(publishable: true) }
  scope :deals_with_revenue, ->{ joins(:orders).where(orders: {status: 'delivered'}).group(:id).select('deals.*, COUNT(orders.id) as orders_count') }
  scope :expiring_soon, ->(order){ joins(:orders).where(orders: { id: order } ).where('published_at < ?', Time.current - LIVE_DEAL_DURATION - MINIMUM_TIME_TO_CANCEL_ORDER) }

  def price
    price_in_cents * 0.01
  end

  def discount_price
    discount_price_in_cents * 0.01
  end

  def unit_price
    price_in_cents * 0.01
  end

  def discount_price
    discount_price_in_cents * 0.01
  end

  def deal_price_with_tax
    discount_price + tax_on_deal
  end

  def tax_on_deal
    tax_in_cents * 0.01
  end

  def calculate_tax_on_deal
    self.tax_in_cents = discount_price * tax_percentage
  end
  
  private
  
  def images_count
    deal_images.count
  end

  def scheduled_deals_count
    self.class.publishable_on(self.publish_at).size
  end

  def valid_publish_at
    if publishable && publish_at_changed?
      unless publish_at - Time.current > MINIMUM_PUBLISH_TIME_GAP
        errors.add :base, "Cannot update publish time 24 hours before deal going live"
      end
    end
  end

  def expiring_soon?
    published_date + TWENTY_FOUR_HOURS - Time.current < THIRTY_MINUTES
  end
end

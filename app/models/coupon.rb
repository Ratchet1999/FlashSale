class Coupon < ApplicationRecord
  enum :status, { inactive: 0, active: 1}
  enum :coupon_type, { flat: 0, percent: 1}

  validates :coupon_type, :value, :currency, presence: true
  validates :value, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: CURRENCIES }

  define_callbacks :active
  set_callback :active, :before, :before_active

  def active
    run_callbacks :active do
      active!
    end
  end

  def before_active
    Coupon.update_all(status: :inactive)
  end

  def value_in_cents
    value * 100
  end
end

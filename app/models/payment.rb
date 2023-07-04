class Payment < ApplicationRecord
  enum :status, { pending: 0, failed: 1, successful: 2 }

  belongs_to :order

  def total_amount
    total_amount_in_cents * 0.01
  end
end

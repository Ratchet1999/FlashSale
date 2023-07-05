class Refund < ApplicationRecord
  enum :status, { 
    pending: 0,
    failed: 1,
    successful: 2
  }

  validates :status, inclusion: { in: %i(pending failed successful), message: "%{value} is not a valid status" }

  belongs_to :order
end

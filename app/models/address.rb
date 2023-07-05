class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :city, :state, :country, :pincode, presence: true
  validates :city, uniqueness: { scope: [:state, :country, :pincode] }
end

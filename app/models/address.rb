class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :city, :state, :country, :pincode, presence: true
end

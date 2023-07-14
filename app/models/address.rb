class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :city, :state, :country, :pincode, presence: true
  validates :city, uniqueness: { scope: [:state, :country, :pincode] }

  # before_validation :check_duplicate_address, on: :create

  # scope :find_address,->(city,state,country,pincode,user){ where(city: city, state: state, country: country, pincode: pincode, user: user) }

  # def check_duplicate_address
  #   errors.add(:base,'Address already exists') unless self.class.find_address(city,state,country,pincode,user).empty?
  # end
end

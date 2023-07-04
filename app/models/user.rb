class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true

  after_create :generate_auth_token

  def generate_auth_token
    regenerate_auth_token
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  validates :first_name, presence: true
end

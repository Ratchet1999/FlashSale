class User < ApplicationRecord
  include Discard::Model
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  has_many :orders
  has_many :payments, through: :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true

  after_create :generate_auth_token
  
  scope :customers_orders, ->(from = Date.current, to = Date.current){ joins(:orders).where('DATE(order_at) BETWEEN ? AND ?', from, to).where(orders: { status: 'delivered' }).group(:id).reselect('users.*, SUM(orders.net_in_cents) as total_amount') }
  scope :orders_by_email, ->{ includes(:orders).where(status: 'delivered') }

  def generate_auth_token
    regenerate_auth_token
  end

  def soft_delete
    update(deactivated_at: Time.current)
  end
  
  def active_for_authentication?
    super && deactivated_at.nil?
  end
end

class StripeHandler
  def initialize(success_url, cancel_url, order)
    @success_url = success_url
    @cancel_url = cancel_url
    @order = order
  end

  def create_stripe_session
    Stripe::Checkout::Session.create( 
      line_items: generate_line_items,
      mode: 'payment',
      success_url: @success_url,
      cancel_url: @cancel_url
    )
  end

  def self.retrieve_session(order)
    Stripe::Checkout::Session.retrieve(order.payments.last.session_id)
  end

  def generate_line_items
    @order.line_items.map do |line_item|
      { quantity: 1,
        price_data: {
          currency: 'inr',
          unit_amount: line_item.net_price.to_i * 100,
          product_data: { 
            name: line_item.deal.title 
          }
        }
      }
    end
  end
end

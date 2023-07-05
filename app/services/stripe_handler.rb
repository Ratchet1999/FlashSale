class StripeHandler
  attr_accessor :messages

  def initialize(success_order_url: nil, cancel_payment_order_url: nil, order:)
    @success_url = success_order_url
    @cancel_url = cancel_payment_order_url
    @order = order
    @messages = {}
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

  def create_refund
    begin
      refund = Stripe::Refund.create({ payment_intent: get_payment_intent })
      messages[:notice] = "Refund successful! Refund ID: #{refund.id}"
      refund
    rescue Stripe::StripeError => e
      messages[:alert] = "Stripe Error: #{e.message}"
    rescue => e
      messages[:alert] = "Error: #{e.message}"
    end
  end

  def get_payment_intent
    Stripe::PaymentIntent.retrieve(@order.payments.successful.first.payment_intent)
  end

  def generate_line_items
    @order.line_items.map do |line_item|
      { quantity: 1,
        price_data: {
          currency: 'inr',
          unit_amount: line_item.net_in_cents,
          product_data: { 
            name: line_item.deal.title 
          }
        }
      }
    end
  end
end

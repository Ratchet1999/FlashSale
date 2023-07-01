class StripeRefundHandler
  attr_accessor :messages

  def initialize(order)
    @order = order
    @messages = {}
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
end

class Api::UsersController < Api::BaseController
  skip_forgery_protection
  before_action :current_api_user, only: %i[my_orders cancel_order]
  
  def my_orders 
    render json: @user.orders, each_serializer: OrderSerializer
  end

  def cancel_order
    user_order = @user.orders.find_by(id: params[:id])
    if user_order.deals.any? { |deal| deal.expiring_soon? }
      render json: { error: "Order can't be cancelled 30 minutes before the deal ends" }.to_json
    else
      refund = StripeRefundHandler.new(@order).create_refund
      @order.refunds.create(refund_id: refund.id, currency: 'inr', total_amount_in_cents: refund.amount).successful!
      @order.cancelled!
      OrderMailer.with(order: @order, refund_id: refund.id).cancelled.deliver_later
      user_order.line_items.each do |line_item|
        line_item.deal.increment!(:quantity)
      end
    end
  end
end

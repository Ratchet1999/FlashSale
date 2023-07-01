class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[deliver_order cancel_order]
  
  def index
    if params[:email]
      @orders = User.find_by(email: params[:email]).orders.not_in_rogress
      flash[:notice] = 'No orders found' if @orders.empty?
    else
      @orders = Order.not_in_progress
    end
  end

  def deliver_order
    @order.delivered!
    OrderMailer.with(order: @order).delivered.deliver_later
    redirect_back fallback_location: admin_orders_path
  end

  def cancel_order
    refund_session = StripeRefundHandler.new(@order)
    refund = refund_session.create_refund
    unless refund_session.messages[:alert]
      @order.cancel_order(refund)
      flash[:notice] = refund_session.messages[:notice]
    else
      flash[:alert] = refund_session.messages[:alert]
    end
    redirect_back fallback_location: admin_orders_path
  end

  private 

  def set_order
    @order = Order.find_by(id: params[:id])
    redirect_back fallback_location: admin_orders_path, alert: "Order Not found" unless @order
  end
end

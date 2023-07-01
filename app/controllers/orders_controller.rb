class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy payment success cancel cancel_order]
  before_action :set_line_item, only: [:remove_from_cart]
  before_action :set_deal, only: [:add_to_cart]

  def index
    @orders = Order.placed_orders
    @orders = current_user.orders.not_in_progress if params[:user_id]
  end

  def new
    @order = Order.new
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to root_path, notice: "Order was successfully placed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      payment
    else
      render :checkout 
    end
  end

  def destroy
    if @order.destroy
      redirect_to root_path, notice: "Order was successfully cancelled."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def cart
    @order = Order.includes(:line_items).where(id: current_order.id).first
    if @order.line_items.empty?
      redirect_to root_path, alert: "You have no deals selected"
    end
  end

  def add_to_cart
    if current_user.orders.deal_exists(@deal.id).any?
      redirect_to root_path, alert: 'You can only buy one quantity of this deal'
    else
      @line_item = current_order.line_items.create(
        deal_id: @deal.id,
        quantity: 1,
        discount_price_in_cents: @deal.discount_price_in_cents,
        price_in_cents: @deal.price_in_cents
      )
      @deal.decrement!(:quantity, 1)
      if @deal.quantity.zero?
        ActionCable.server.broadcast(
          "deal_status_channel",
           {
             deal_id: @deal.id,
             quantity: @deal.quantity
           }
          )
      end
      redirect_to root_path, notice: 'Item Added'
    end
  end

  def remove_from_cart
    @deal = Deal.find(@line_item.deal.id)
    quantity = @deal.quantity
    if current_order.line_items.destroy(@line_item)
      @deal.increment!(:quantity, 1)
      if quantity.zero?
        ActionCable.server.broadcast(
          "deal_status_channel",
           {
             deal_id: @deal.id,
             quantity: @deal.quantity
           }
        )
      end
      redirect_back fallback_location: root_path
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def checkout
    @order = current_order
  end

  def payment
    stripe_session = StripeHandler.new(success_order_url, cancel_order_url, @order).create_stripe_session
    @order.payments.create(session_id: stripe_session.id, currency: stripe_session.currency, status: 'pending', total_amount_in_cents: @order.net_in_cents)
    redirect_to stripe_session.url, allow_other_host: true
  end

  def success
    checkout_session = StripeHandler.retrieve_session(@order)
    ActiveRecord::Base.transaction do
      @order.update_columns({ status: 'placed', order_at: Time.current })
      @order.payments.last.update_columns({ status: 'successful', payment_intent: checkout_session.payment_intent })
    end
    OrderMailer.with(order: current_user.orders.placed.last).received.deliver_later
  end

  def cancel
    @order.payments.last.failed!
    redirect_to checkout_order_path, alert: 'Payment was cancelled'
  end

  def cancel_order
    if Deal.expiring_soon(@order)
      flash[:notice] = "Order can't be cancelled 30 minutes before the deal ends"
    else
      refund_session = StripeRefundHandler.new(@order)
      refund = refund_session.create_refund
      unless refund.messages[:alert]
        @order.cancel_order(refund)
        @order.line_items.each do |line_item|
          line_item.deal.increment!(:quantity)
        end
        flash[:notice] = refund.messages[:notice]
      else
        flash[:notice] = refund.messages[:alert]
      end
    end
    redirect_back fallback_location: order_path(@order)
  end

  private 

  def set_order
    @order = Order.find_by(id: params[:id])
    redirect_to root_path, alert: "Order Not found" unless @order
  end

  def order_params
    params.require(:order).permit( :status , :address_id )
  end 

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end
end

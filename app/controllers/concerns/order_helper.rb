module OrderHelper
  def current_order
    current_orders = current_user.orders.in_progress
    @order = current_orders.last || current_orders.create
  end
end

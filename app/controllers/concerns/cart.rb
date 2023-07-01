module Cart
  def current_order
    @order = current_user.orders.in_progress.last || Order.in_progress.create(user_id: current_user.id)
  end
end

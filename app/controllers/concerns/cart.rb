module Cart
  def current_order
    @order = current_user.orders.in_progress.last || Order.create(user_id: current_user.id).in_progress!
  end
end

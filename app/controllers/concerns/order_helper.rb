module OrderHelper
  def current_order
    current_orders = current_user.orders.in_progress
    @order = current_orders.last || current_orders.create
  end

  def user_wishlist
    wishlist = current_user.orders.wishlist
    @wishlist = wishlist.first || wishlist.create
  end
end

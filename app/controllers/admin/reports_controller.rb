class Admin::ReportsController < Admin::BaseController
  def index
  end

  def deals
    @deals = Deal.deals_with_revenue
    flash[:notice] = 'No customers found' if @deals.empty?
  end

  def customers
    if params[:from].present? && params[:to].present?
      @customers = User.customers_orders(params[:from]&.to_datetime, params[:to].to_datetime)
    else
      @customers = User.customers_orders
    end
  end
end

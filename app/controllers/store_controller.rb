class StoreController < ApplicationController
  skip_before_action :authenticate_user!

  def homepage
    @live_deals = Deal.live
    @expired_deals = Deal.expired if @live_deals.empty?
  end

  def past_deals
    @deals = Deal.expired
  end
end

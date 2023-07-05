class DealStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "deal_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

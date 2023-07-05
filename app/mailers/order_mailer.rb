class OrderMailer < ApplicationMailer
  default from: 'FlashDeals'

  before_action :add_attachments
  
  def received
    mail to: @order.user.email, subject: 'FlashDeal Store Order Confirmation'
  end

  def delivered
    mail to: @order.user.email, subject: 'FlashDeal Store Order Delivered'
  end

  def cancelled
    mail to: @order.user.email, subject: 'FlashDeal Store Order Cancellation'
  end

  private def add_attachments
    @order = params[:order]
    @order.line_items.each do |line_item|
      deal_images = line_item.deal.deal_images.to_a
      attachments.inline["#{line_item.id}_first.jpg"] = deal_images.shift.image.download
      deal_images.each do |deal_image|
        attachments["#{line_item.id}_#{deal_image.image.id}.jpg"] = deal_image.image.download
      end
    end
  end
end

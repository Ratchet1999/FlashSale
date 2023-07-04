class OrderMailer < ApplicationMailer
  default from: 'FlashDeals'
  
  def received(order)
    @order = order
    order.line_items.each do |line_item|
      deal_images = line_item.deal.deal_images.to_a
      attachments.inline["#{line_item.id}_first.jpg"] = deal_images.shift.image.download
      deal_images.each do |deal_image|
        attachments["#{line_item.id}_#{deal_image.image.id}.jpg"] = deal_image.image.download
      end
    end

    mail to: order.user.email, subject: 'FlashDeal Store Order Confirmation'
  end
end

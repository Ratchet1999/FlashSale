require 'sidekiq-scheduler'

class PublishingDeals
  include Sidekiq::Worker

  def perform
    system('rake publishing_deals')
  end
end

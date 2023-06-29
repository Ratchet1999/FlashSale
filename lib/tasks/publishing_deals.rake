desc "Publish Deals Everyday at 10 am"
task :publishing_deals => :environment do
  @publishing_deals = Deal.to_publish
  @unpublishing_deals = Deal.to_unpublish
  published_deals_count = 0
  @publishing_deals.each do |deal|
    if published_deals_count < MAXIMUM_DEALS_TO_SCHEDULE && deal.update(published_at: Time.current)
      published_deals_count += 1
    else
      deal.update_column(:publish_at, Time.current + RESCHEDULE_TIME_GAP)
    end
  end
  @unpublishing_deals.each do |deal|
    deal.update_column(:publishable, false)
  end
end

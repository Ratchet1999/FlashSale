class Currency < ApplicationRecord
  validate :conversion_rates_presence

  before_validation :set_date

  def self.current_rate
    rates = last.conversion_rates
    rates = { "usd"=> "1"} if rates.empty?
    rates
  end

  def set_date
    self.date = Date.current
  end

  def self.rate_on(name, date)
    where(date: ..date).last.conversion_rates[name].to_f
  end

  private

  def conversion_rates_presence
    errors.add(:base, 'Please enter all conversion rates') if conversion_rates.empty? || conversion_rates.values.any?(&:blank?)
  end
end

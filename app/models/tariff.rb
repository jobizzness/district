class Tariff < ActiveRecord::Base
  has_many :users

  def entire_price
    price_per_month * duration
  end

  def entire_price_in_cent
    (entire_price * 100).to_i
  end

  def free?
    price_per_month.nil? || price_per_month == 0
  end
end

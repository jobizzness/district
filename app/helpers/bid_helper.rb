module BidHelper
  def bid_price bid
    number_to_currency bid.total_price, delimiter: '', precision: 0, format: '%n'
  end
end
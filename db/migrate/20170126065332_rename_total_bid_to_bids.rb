class RenameTotalBidToBids < ActiveRecord::Migration
  def change
    rename_column :bids, :total_bid, :total_price
  end
end

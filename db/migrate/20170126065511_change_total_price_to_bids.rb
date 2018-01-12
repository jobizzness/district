class ChangeTotalPriceToBids < ActiveRecord::Migration
  def change
    change_column :bids, :total_price, :integer, default: 0
  end
end

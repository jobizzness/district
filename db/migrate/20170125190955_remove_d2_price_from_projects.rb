class RemoveD2PriceFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :d2_price
    remove_column :projects, :bid_price
    remove_column :projects, :total_price
  end
end

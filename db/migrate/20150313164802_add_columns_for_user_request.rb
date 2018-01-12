class AddColumnsForUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :description, :text
    add_column :user_requests, :d2_price, :decimal, precision: 10, scale: 2
    add_column :user_requests, :bid_price, :decimal, precision: 10, scale: 2
    add_column :user_requests, :total_price, :decimal, precision: 10, scale: 2
  end
end

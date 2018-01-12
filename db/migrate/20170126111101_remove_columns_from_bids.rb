class RemoveColumnsFromBids < ActiveRecord::Migration
  def change
    remove_column :bids, :payment_credit_card, :string
    remove_column :bids, :payment_check, :string
    remove_column :bids, :payment_cash, :string
    remove_column :bids, :payment_paypal, :string
    remove_column :bids, :payment_western_union, :string
    remove_column :bids, :payment_other, :string
  end
end

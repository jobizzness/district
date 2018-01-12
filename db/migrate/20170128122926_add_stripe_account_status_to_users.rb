class AddStripeAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_account_status, :text
  end
end

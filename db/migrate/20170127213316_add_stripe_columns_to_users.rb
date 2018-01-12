class AddStripeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_publishable_key, :string
    add_column :users, :stripe_secret_key, :string
    add_column :users, :stripe_user_id, :string
  end
end

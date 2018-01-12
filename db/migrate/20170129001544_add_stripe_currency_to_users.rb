class AddStripeCurrencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_currency, :string
  end
end

class AddExternalCustomerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :external_customer_id, :string
  end
end

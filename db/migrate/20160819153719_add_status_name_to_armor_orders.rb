class AddStatusNameToArmorOrders < ActiveRecord::Migration
  def change
    add_column :armor_orders, :status_name, :string
  end
end

class RemoveArmorTables < ActiveRecord::Migration
  def change
    drop_table :armor_orders
    drop_table :armor_profiles
  end
end

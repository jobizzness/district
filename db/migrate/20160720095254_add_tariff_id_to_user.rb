class AddTariffIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :tariff_id, :integer, default: 0
  end
end

class AddStartTariffAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :start_tariff_at, :datetime
  end
end

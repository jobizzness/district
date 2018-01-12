class AddMadeProductionToStep2s < ActiveRecord::Migration
  def change
    add_column :step2s, :made_production, :string
  end
end

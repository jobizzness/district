class AddDistributionToStep2s < ActiveRecord::Migration
  def change
    add_column :step2s, :distribution, :string
  end
end

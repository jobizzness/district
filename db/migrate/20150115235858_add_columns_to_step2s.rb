class AddColumnsToStep2s < ActiveRecord::Migration
  def change
    add_column :step2s, :number_of_color_ways, :string
    add_column :step2s, :size_range, :string
    add_column :step2s, :desired_trims, :string
  end
end

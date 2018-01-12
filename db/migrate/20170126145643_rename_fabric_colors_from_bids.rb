class RenameFabricColorsFromBids < ActiveRecord::Migration
  def change
    rename_column :bids, :fabric_colors, :additional_info
  end
end

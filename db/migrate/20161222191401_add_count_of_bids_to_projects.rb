class AddCountOfBidsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :count_of_bids, :integer, default: 0
  end
end

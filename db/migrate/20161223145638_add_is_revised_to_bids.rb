class AddIsRevisedToBids < ActiveRecord::Migration
  def change
    add_column :bids, :is_revised, :boolean, default: false
  end
end

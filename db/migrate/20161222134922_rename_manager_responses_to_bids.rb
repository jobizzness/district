class RenameManagerResponsesToBids < ActiveRecord::Migration
  def change
    rename_table :manager_responses, :bids
    rename_column :questions, :manager_response_id, :bid_id
  end
end

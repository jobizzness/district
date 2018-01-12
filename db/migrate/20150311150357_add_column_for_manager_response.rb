class AddColumnForManagerResponse < ActiveRecord::Migration
  def change
    add_column :manager_responses, :total_bid, :string, default: ''
  end
end

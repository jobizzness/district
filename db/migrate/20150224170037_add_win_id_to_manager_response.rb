class AddWinIdToManagerResponse < ActiveRecord::Migration
  def change
    add_column :manager_responses, :win_id, :integer
  end
end

class AddUserIdToManagerResponse < ActiveRecord::Migration
  def change
    add_column :manager_responses, :user_id, :integer
  end
end

class AddUserIdToUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :user_id, :integer
  end
end

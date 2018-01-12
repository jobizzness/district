class AddColumnStatusForUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :status, :integer, default: 0
  end
end

class RemoveColumnActiveFromUserRequest < ActiveRecord::Migration
  def change
    remove_column :user_requests, :active
  end
end

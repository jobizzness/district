class AddActiveAndAvailableToToUserRequest < ActiveRecord::Migration
  def change
    add_column :user_requests, :available_to, :datetime
    add_column :user_requests, :active, :boolean
  end
end

class ChangeColumnActiveFromUserRequest < ActiveRecord::Migration
  def change
    change_column :user_requests, :active, :boolean, default: true
  end
end

class ChangeColumnsInUsersConnections < ActiveRecord::Migration
  def change
    rename_column :users_connections, :id_company, :company_id
    rename_column :users_connections, :id_user, :user_id
  end
end

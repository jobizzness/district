class RemoveAmdminTables < ActiveRecord::Migration
  def change
    drop_table :admin_error_log
    drop_table :admin_log
    drop_table :admin_menu
    drop_table :admin_notification_type
    drop_table :admin_notifications
    drop_table :admin_notifications_user
    drop_table :admin_rights
    drop_table :admin_rights_role_connection
    drop_table :admin_rights_roles
    drop_table :admin_rights_user_role
    drop_table :admin_system
    drop_table :admin_users
  end
end

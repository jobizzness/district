class RenameUserRequestsToProjects < ActiveRecord::Migration
  def change
    rename_table :user_requests, :projects
  end
end

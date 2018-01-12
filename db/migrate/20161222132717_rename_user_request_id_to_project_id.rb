class RenameUserRequestIdToProjectId < ActiveRecord::Migration
  def change
    rename_column :wins, :user_request_id, :project_id
    rename_column :step1s, :user_request_id, :project_id
    rename_column :step2s, :user_request_id, :project_id
    rename_column :step3s, :user_request_id, :project_id
    rename_column :step4s, :user_request_id, :project_id
    rename_column :questions, :user_request_id, :project_id
    rename_column :attachments, :user_request_id, :project_id
  end
end

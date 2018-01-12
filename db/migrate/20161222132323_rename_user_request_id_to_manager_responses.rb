class RenameUserRequestIdToManagerResponses < ActiveRecord::Migration
  def change
    rename_column :manager_responses, :user_request_id, :project_id
  end
end

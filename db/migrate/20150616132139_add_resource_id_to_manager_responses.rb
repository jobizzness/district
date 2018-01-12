class AddResourceIdToManagerResponses < ActiveRecord::Migration
  def change
    add_column :manager_responses, :resource_id, :string
  end
end

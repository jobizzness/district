class AddFactoryLocationWebsiteAddressToManagerResponses < ActiveRecord::Migration
  def change
    add_column :manager_responses, :factory_location, :string
    add_column :manager_responses, :website_address, :string
  end
end

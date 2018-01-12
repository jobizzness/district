class AddFieldsToArmorProfile < ActiveRecord::Migration
  def change
    add_column :armor_profiles, :url, :string
    add_column :armor_profiles, :inc_country, :string
    add_column :armor_profiles, :inc_state, :string
    add_column :armor_profiles, :business_type, :integer
  end
end

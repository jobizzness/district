class AddArmorUserIdToArmorProfiles < ActiveRecord::Migration
  def change
    add_column :armor_profiles, :armor_user_id, :bigint
    change_column :armor_profiles, :account_id, :bigint, default: nil
  end
end

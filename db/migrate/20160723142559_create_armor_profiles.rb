class CreateArmorProfiles < ActiveRecord::Migration
  def change
    create_table :armor_profiles do |t|
      t.references :user, index: true
      t.string :company
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :user_phone
      t.string :user_name
      t.string :user_email

      t.integer :account_type
      t.string :company_type
      t.string :uri
      t.string :account_id, default: ''
      t.integer :status, nul: false, default: 0

      t.timestamps null: false
    end
    add_foreign_key :armor_profiles, :users
  end
end

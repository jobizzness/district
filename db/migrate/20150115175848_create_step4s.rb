class CreateStep4s < ActiveRecord::Migration
  def change
    create_table :step4s do |t|
      t.string :contact_full_name
      t.string :contact_phone
      t.string :contact_email
      t.string :contact_city
      t.string :contact_state
      t.string :contact_zip

      t.references :user_request, index: true
      t.timestamps
    end
  end
end

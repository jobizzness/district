class CreateStep3s < ActiveRecord::Migration
  def change
    create_table :step3s do |t|
      t.boolean :check_type_branding, default: false
      t.boolean :check_type_creative_direction, default: false
      t.boolean :check_type_design, default: false
      t.boolean :check_type_technical_design, default: false
      t.boolean :check_type_sampling, default: false
      t.boolean :check_type_production, default: false
      t.boolean :check_type_website, default: false
      t.boolean :check_type_social, default: false
      t.datetime :desired_completion
      t.text :additional_info
      t.references :user_request, index: true

      t.timestamps
    end
  end
end

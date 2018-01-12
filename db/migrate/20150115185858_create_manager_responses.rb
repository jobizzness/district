class CreateManagerResponses < ActiveRecord::Migration
  def change
    create_table :manager_responses do |t|
      t.string :logo_file_name
      t.string :logo_file_size
      t.string :logo_content_type
      t.string :product_description
      t.string :factory_name
      t.string :factory_expirience
      t.string :email
      t.string :moq_per_style
      t.string :moq_per_order
      t.integer :max_amount_colors

      t.text :total_sample_pricing

      t.decimal :cost_sample_shipping, precision: 9, scale: 2
      t.decimal :production_shipping_cost, precision: 9, scale: 2

      t.text :production_cost

      t.string :lead_time_samples
      t.string :lead_time_production
      t.text :fabric_colors
      t.boolean :payment_credit_card
      t.boolean :payment_check
      t.boolean :payment_cash
      t.text :payment_term_production
      t.references :user_request, index: true

      t.string :pdf_file_name
      t.string :pdf_file_size
      t.string :pdf_content_type

      t.timestamps
    end
  end
end

class CreateStep2s < ActiveRecord::Migration
  def change
    create_table :step2s do |t|
      t.string :type_of_product
      t.integer :samples_number
      t.datetime :samples_date
      t.string :how_many_styles
      t.string :units_per_style
      t.string :made_in_country
      t.datetime :completion_date
      t.references :user_request, index: true

      t.timestamps
    end
  end
end

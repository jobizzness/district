class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.string :name
      t.text :description
      t.float :price_per_month, default: 0
      t.integer :duration
      t.timestamps
    end
  end
end

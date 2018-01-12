class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.integer :amount, default: 0
      t.references :user, index: true
      t.references :bid, index: true
      t.timestamps
    end
  end
end

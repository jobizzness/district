class CreateArmorOrders < ActiveRecord::Migration
  def change
    create_table :armor_orders do |t|
      t.bigint :order_id
      t.bigint :buyer_id
      t.bigint :seller_id
      t.integer :bid_id
      t.integer :status # completed, rejected, in progress
      t.float :amount
      t.string :summary, limit: 100
      t.text :description, limit: 10000
      t.integer :invoice_num
      t.integer :purchase_order_num
      t.datetime :status_change
      t.string :uri
      t.timestamps
    end

    add_index :armor_orders, :order_id
    add_index :armor_orders, :buyer_id
    add_index :armor_orders, :seller_id
    add_index :armor_orders, :bid_id
  end
end

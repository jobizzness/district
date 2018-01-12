class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.text :body
      t.integer :bid_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :chat_messages, :bid_id
    add_index :chat_messages, :user_id
  end
end

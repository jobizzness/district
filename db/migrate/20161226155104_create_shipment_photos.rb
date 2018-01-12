class CreateShipmentPhotos < ActiveRecord::Migration
  def change
    create_table :shipment_photos do |t|
      t.attachment :file
      t.references :bid, index: true
      t.references :chat_message, index: true
      t.timestamps null: false
    end
  end
end

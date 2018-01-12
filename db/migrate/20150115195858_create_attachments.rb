class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_file_size
      t.string :attachment_content_type
      t.references :user_request, index: true

      t.timestamps
    end
  end
end

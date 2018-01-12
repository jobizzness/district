class ChangeTypeAttachmentSize < ActiveRecord::Migration
  def change
    change_column :attachments, :attachment_file_size, :integer
  end
end

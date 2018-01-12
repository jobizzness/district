class CreateUserRequests < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      t.string :pdf_file_name
      t.string :pdf_file_size
      t.string :pdf_content_type

      t.timestamps
    end
  end
end

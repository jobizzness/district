class CreateWins < ActiveRecord::Migration
  def change
    create_table :wins do |t|
      t.belongs_to :user_request, index: true
      t.timestamps
    end
  end
end

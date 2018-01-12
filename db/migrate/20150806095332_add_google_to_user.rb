class AddGoogleToUser < ActiveRecord::Migration
  def change
    add_column :users, :google, :string
  end
end

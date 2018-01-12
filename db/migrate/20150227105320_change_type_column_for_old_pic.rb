class ChangeTypeColumnForOldPic < ActiveRecord::Migration
  def change
    change_column :companies_pics, :pic_old, :string, default: ''
  end
end

class ChangePicToPicOldInPress < ActiveRecord::Migration
  def change
    rename_column :press, :pic, :pic_old
  end
end

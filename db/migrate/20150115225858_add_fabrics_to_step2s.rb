class AddFabricsToStep2s < ActiveRecord::Migration
  def change
    add_column :step2s, :fabrics, :text
    add_column :step2s, :artwork, :text
  end
end

class AddHashTagsToStep1s < ActiveRecord::Migration
  def change
    add_column :step1s, :hash_tags, :text
  end
end

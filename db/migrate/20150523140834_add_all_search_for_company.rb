class AddAllSearchForCompany < ActiveRecord::Migration
  def change
    add_column :companies, :search_all, :text
  end
end

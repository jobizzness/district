class ChangeFieldsInCompanies < ActiveRecord::Migration
  def change
    change_column :companies, :address1, :string, :default => ''
  end
end

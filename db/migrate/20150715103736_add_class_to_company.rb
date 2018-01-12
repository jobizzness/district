class AddClassToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :class_type, :string
  end
end

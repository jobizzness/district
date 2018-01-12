class AddFieldsToManagerResponses < ActiveRecord::Migration
  def change
    add_column :manager_responses, :payment_paypal, :boolean
    add_column :manager_responses, :payment_western_union, :boolean
    add_column :manager_responses, :payment_other, :string
  end
end

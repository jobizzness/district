class CreateStep1s < ActiveRecord::Migration
  def change
    create_table :step1s do |t|
      t.string :overall_of_budget
      t.string :business_type
      t.references :user_request, index: true

      t.timestamps
    end
  end
end

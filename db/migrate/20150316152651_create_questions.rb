class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :verbal
      t.integer :question_id, default: 0
      t.references :user_request, index: true
      t.references :manager_response, index: true
      t.references :user, index: true
      t.references :manager, index: true
      t.boolean :replied, default: false

      t.timestamps
    end
  end
end

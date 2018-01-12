class RemoveDesiredCompletionFromStep3s < ActiveRecord::Migration
  def change
    remove_column :step3s, :desired_completion
  end
end

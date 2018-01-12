class UsaState < ActiveRecord::Base
  scope :all_data, -> { select(:code, :name).order(:name) }
end

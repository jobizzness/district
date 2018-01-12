class Win < ActiveRecord::Base
  belongs_to :project
  has_one :bid
end

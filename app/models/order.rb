class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :bid

  validates_presence_of :title, :user_id
end
class ChatMessage < ActiveRecord::Base
  belongs_to :bid
  belongs_to :user

  has_many :shipment_photos

  validates_presence_of :body, :bid_id, :user_id

  def date
    created_at.strftime('%m.%d.%y') if created_at
  end

  def time
    created_at.strftime('%I:%M %p') if created_at
  end
end

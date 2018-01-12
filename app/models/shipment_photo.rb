class ShipmentPhoto < ActiveRecord::Base
  belongs_to :bid
  belongs_to :chat_message

  has_attached_file :file,
    styles: { small: '80x80#',
              medium: '200x200#' }

  validates_attachment :file,
    content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
    size: { less_than: 5.megabyte },
    presence: true

  validates_presence_of :bid_id, :chat_message_id
end

class Bid < ActiveRecord::Base
  serialize :total_sample_pricing
  serialize :production_cost

  has_one :order

  belongs_to :user
  belongs_to :project, counter_cache: :count_of_bids

  has_many :chat_messages, foreign_key: 'bid_id'
  has_many :shipment_photos

  has_attached_file :logo,
    styles: {
      small: '110x95#',
      medium: '240x225#',
      big: '620x420#'
    },
    default_url: '/logos/:style/missing.png'

  validates_attachment :logo, content_type: { content_type: ['image/tiff' ,'image/jpeg', 'image/gif', 'image/png', 'application/pdf']  }
  validates_uniqueness_of :resource_id, on: :update

  has_attached_file :pdf
  do_not_validate_attachment_file_type :pdf

  after_create :generator

  scope :my, ->(user_id) { where('user_id = ?', user_id) }
  scope :wins, -> { where.not(win_id: nil) }
  scope :not_revised, -> { where(is_revised: false) }
  scope :sort_by_newest, -> { order(created_at: :desc) }

  def win?
    win_id.present?
  end

  def not_win?
    win_id.nil?
  end

  private

  def generator
    update_column(:resource_id, ('%06d' % id))
  end
end

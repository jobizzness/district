class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable

  serialize :stripe_account_status, JSON

  enum maker_type: { idea: 0, product: 1 }

  has_many :users_connections
  has_many :companies, through: :users_connections
  has_many :projects
  has_many :bids
  has_many :orders

  belongs_to :tariff

  def full_name
    if first_name.present? || last_name.present?
      [first_name, last_name].compact.join ' '
    else
      name
    end
  end

  def company
    self.companies.first
  end

  def tariff_days_left
    days_left > 0 ? days_left : 0
  end

  def tariff_expired?
    days_left <= 0
  end

  def not_revised_won_bid
    bids.wins.not_revised.first
  end

  def stripe_customer?
    external_customer_id.present?
  end

  def stipe_transfer?
    stripe_account_status.present? && stripe_account_status['transfers_enabled']
  end

  private
    def days_left
      (Time.zone.at(self.start_tariff_at || 0).to_date + (self.tariff.try(:duration) || 0).month - Time.zone.today).to_i
    end
end

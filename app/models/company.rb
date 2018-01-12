class Company < ActiveRecord::Base
  has_many :companies_pics, foreign_key: :id_company

  has_many :users_connections
  has_many :users, through: :users_connections

  has_many :articles_companies_connections, foreign_key: 'id_company'
  has_many :articles, through: :articles_companies_connections

  has_many :companies_tags_connections, foreign_key: 'id_company'
  has_many :tags, through: :companies_tags_connections

  has_many :companies_categories_connections
  has_many :categories, through: :companies_categories_connections

  has_many :companies_subcategories_connections
  has_many :subcategories, through: :companies_subcategories_connections

  has_attached_file :avatar, styles: {
                                small: '160x160#',
                                medium: '320x320#'
                              },
                              default_url: '/companies/avatars/:style/missing.png'

  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_attached_file :logo, styles: {
                                small: '160x160#',
                                medium: '320x320#'
                              },
                              default_url: '/companies/logos/:style/missing.png'

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

  scope :availables, -> { where(available: '1111') }
  scope :order_by_date, -> { order(:created_at) }
  scope :order_by_name, -> { order(:name) }
  scope :order_by_state, ->(state) { where('state = ?', state) }

  scope :search_by_name, ->(name) { where('search_all like ?', '%'+name+'%').limit(4) }
  scope :search_by_description, ->(description) { where('description = ?', description).limit(4) }

  # TODO: ask about this
  # validates_presence_of :name, :address

  after_save :availability

  def user
    self.users.first
  end

  private
    def availability
      data = []

      data << (self.subcategories.any? ? 1 : 0)
      data << (self.avatar.present? ? 1 : 0)
      data << (self.brief.present? ? 1 : 0)
      data << (self.website.present? && self.phone.present? ? 1 : 0)

      str = data.join('')
      self.update_columns(available: str)
    end
end

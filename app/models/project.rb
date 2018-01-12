class Project < ActiveRecord::Base
  enum status: { not_approved: 0, opened: 1, in_work: 2, completed: 3, disputed: 4, cancelled: 5 }

  belongs_to :user

  has_one :win
  has_one :bid, through: :win
  has_one :step1, dependent: :destroy
  has_one :step2, dependent: :destroy
  has_one :step3, dependent: :destroy
  has_one :step4, dependent: :destroy

  has_many :bids, dependent: :destroy
  has_many :attachments, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :step1, :step2, :step3, :step4

  has_attached_file :pdf
  do_not_validate_attachment_file_type :pdf

  scope :my, ->(user_id) { where('user_id = ?', user_id) }
  scope :approved, -> { where.not(status: Project.statuses[:not_approved]) }
  scope :sort_by_oldest, -> { order(created_at: :asc) }
  scope :sort_by_newest, -> { order(created_at: :desc) }

  def bid_win?
    win.present?
  end

  def self.find_projects_by_data(data)
    if data.present?
      project_ids ||= []
      project_ids << Step1.where("hash_tags LIKE ?", "%#{data}%").pluck(:project_id)
      project_ids << Step2.where("type_of_product LIKE ?", "%#{data}%").pluck(:project_id)
      project_ids << Step3.where("additional_info LIKE ?", "%#{data}%").pluck(:project_id)
      if project_ids.flatten.uniq.any? 
        Project.where(id: project_ids.flatten.uniq) 
      else
        []
      end
    end
  end

  def company
    user.company
  end

  def bid_info(user_id)
    data = Bid.where(user_id: user_id, project_id: self.id).first
    return data if data
  end
end

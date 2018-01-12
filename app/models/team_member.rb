class TeamMember < ActiveRecord::Base
  has_attached_file :photo, styles: { medium: '250x250#' },
                            default_url: '/founders/missing.png'

  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\Z/ }
end

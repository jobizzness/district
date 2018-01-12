class UsersConnection < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :company, class_name: 'Company', foreign_key: 'company_id'
end

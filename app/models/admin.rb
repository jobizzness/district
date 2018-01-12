class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :recoverable, :lockable, :rememberable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable
end

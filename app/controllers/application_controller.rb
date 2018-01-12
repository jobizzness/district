class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit

  def after_sign_in_path_for resource
    if current_user
      root_path
    elsif current_manager
      managers_projects_url
    elsif current_admin
      admins_projects_url
    end
  end
end

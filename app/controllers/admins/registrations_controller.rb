class Admins::RegistrationsController < Devise::RegistrationsController
  layout 'admin'

  protected

    def after_update_path_for(resource)
      admins_path
    end
end

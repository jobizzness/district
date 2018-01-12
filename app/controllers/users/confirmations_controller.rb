class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?
    
    if resource.errors.empty?
      sign_in(resource)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      logger.info "####################"
      logger.info "########## after confiramtion ##########"
      logger.info "####################"
      logger.info "#{resource.errors}"
      logger.info "####################"
      logger.info "####################"
      logger.info "####################"
      redirect_to root_url
    end
  end
end

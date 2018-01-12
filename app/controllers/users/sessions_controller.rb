class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user && (user.valid_password?(params[:password]) || is_facebook(user) || is_google(user) || is_linkedin(user))
      scope = Devise::Mapping.find_scope!(:user)
      sign_in scope, user
      render json: { user: user }
    elsif user && user.encrypted_password.blank?
      user.update confirmed_at: DateTime.now
      user.send_reset_password_instructions
      render json: { results: 'reset_password' }
    else
      render json: { messages: 'Invalid email or password' },
                     status: 401
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    redirect_to root_url
  end

  private
    def is_facebook user
      params[:fid].present? && params[:fid] == user.facebook
    end

    def is_google user
      params[:gid].present? && params[:gid] == user.google
    end

    def is_linkedin user
      params[:lid].present? && params[:lid] == user.linkedin
    end
end

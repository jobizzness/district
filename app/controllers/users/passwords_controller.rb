class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  def ajax_update
    if params[:email].present?
      User.find_by(email: params[:email]).send_reset_password_instructions
      render json: { result: 'ok', messages: 'ok' }, status: 200
    else
      render json: { result: 'error', messages: 'Error with your email.' }, status: 401
    end
  end
end

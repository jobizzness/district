class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(user_params)

    if @user.save
      if @user.product? && !@user.tariff.free?
        customer = register_with_credit_card_service
        if customer
          add_customer_id_to_user(customer['id'])
          if charge_with_credit_card_service(customer['id'])
            add_start_tariff_time 
            add_order
          end
        end
      end
      add_company_to_user
      render json: :ok
    else
      render json: { result: 'error', messages: @user.errors.full_messages.to_sentence }, status: 401
    end
  end

  private

  def credit_card_service
    CreditCardService.new(
      source: params[:stripe_token],
      amount: @user.tariff.entire_price_in_cent,
      email: user_params[:email],
      description: "Paid for tariff plan '#{@user.tariff.name}'"
    )
  end

  def register_with_credit_card_service
    credit_card_service.create_customer
  end

  def charge_with_credit_card_service customer_id
    credit_card_service.charge_by_customer customer_id
  end

  def add_customer_id_to_user(id)
    @user.update_column(:external_customer_id, id)
  end

  def add_start_tariff_time
    @user.update_column(:start_tariff_at, Time.zone.now)
  end

  def add_company_to_user
    company = Company.create(name: '', address: '')
    @user.companies << company
  end

  def add_order
    @user.orders.create(
      title: "Paid for tariff plan '#{@user.tariff.name}'",
      amount: @user.tariff.entire_price
    )
  end

  def user_params
    params.require(:user).permit(:maker_type, :first_name, :last_name, :name, :email, :password, :password_confirmation, :tariff_id)
  end
end

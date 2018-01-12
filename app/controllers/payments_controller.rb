class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :stripe_managed_service, only: [:index, :managed, :account]

  def index
    @orders = current_user.orders
    @stripe_account_status = current_user.stripe_account_status
  end

  def managed
    account = @manager.create_account(
      params[:country],
      params[:tos] == 'on',
      request.remote_ip
    )

    if account
      flash[:notice] = 'Managed Stripe account created!'
    else
      flash.now[:managed] = { error: 'Unable to create Stripe account!' }
    end

    redirect_to payments_path(tab: :account)
  end

  def account
    begin
      @manager.update_account(params: params)  
    rescue => e
      flash.now[:stripe] = { error: e.message }
    end
    redirect_to payments_path(tab: :account)
  end

  def set_maker_type
    if current_user.maker_type.nil?
      current_user.update(maker_type: params[:maker_type])
      render json: :ok
    else
      render json: :bad
    end
  end

  def set_tariff
    if current_user.product?
      current_user.update(tariff_id: params[:tariff_id])
      render json: :ok
    else
      render json: :bad
    end
  end

  def pay_tariff
    customer_id = 
      if current_user.stripe_customer?
        current_user.external_customer_id
      else
        customer = register_with_credit_card_service
        if customer
          add_customer_id_to_user(customer['id'])
          customer['id']
        end
      end

    if customer_id && charge_with_credit_card_service(customer_id)
      add_start_tariff_time
      add_order
      head :ok
    else
      render json: { message: 'Something went wrong...' }, status: :bad
    end
  end

  private

  def credit_card_service
    CreditCardService.new(
      source: params[:stripe_token],
      amount: current_user.tariff.entire_price_in_cent,
      email: current_user.email,
      description: "Paid for tariff plan '#{current_user.tariff.name}'"
    )
  end

  def register_with_credit_card_service
    credit_card_service.create_customer
  end

  def charge_with_credit_card_service customer_id
    credit_card_service.charge_by_customer customer_id
  end

  def add_customer_id_to_user(id)
    current_user.update_column(:external_customer_id, id)
  end

  def add_start_tariff_time
    current_user.update_column(:start_tariff_at, Time.zone.now)
  end

  def add_order
    current_user.orders.create(
      title: "Paid for tariff plan '#{current_user.tariff.name}'",
      amount: current_user.tariff.entire_price
    )
  end

  def stripe_managed_service
    @manager = StripeManagedService.new(current_user)
  end
end

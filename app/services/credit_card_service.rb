require 'stripe'

class CreditCardService
  def initialize(params)
    @source = params[:source]
    @amount = params[:amount]
    @email = params[:email]
    @description = params[:description]
  end

  def create_customer
    begin
      # This will return a Stripe::Customer object
      external_customer_service.create(customer_attributes)
    rescue
      false
    end
  end

  def charge_by_customer customer_id
    begin
      # This will return a Stripe::Charge object
      external_charge_service.create(charge_by_customer_attributes.merge customer: customer_id)
    rescue
      false
    end    
  end

  def charge
    begin
      # This will return a Stripe::Charge object
      external_charge_service.create(charge_attributes)
    rescue
      false
    end
  end

  private

  attr_reader :source, :amount, :email, :description

  def external_charge_service
    Stripe::Charge
  end

  def external_customer_service
    Stripe::Customer
  end

  def charge_by_customer_attributes
    {
      amount: amount,
      currency: 'usd',
      description: description
    }
  end

  def charge_attributes
    {
      source: source,
      amount: amount,
      currency: 'usd',
      description: description
    }
  end

  def customer_attributes
    {
      email: email,
      source: source
    }
  end  
end

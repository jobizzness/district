module PaymentHelper
  def tariffs
    Tariff.all
  end

  def tariff_indicator
    return if current_user.idea? || !user_signed_in?
    content_tag :div, class: 'tariff-indicator' do
      concat content_tag :span, current_user.tariff.try(:name)
      concat content_tag :span, pluralize(current_user.tariff_days_left, 'day'), class: ('expired js-pay-the-tariff' if current_user.tariff_expired?) unless current_user.tariff.free?
    end if current_user.tariff_id?
  end

  def payment_price price
    number_to_currency price, delimiter: '', precision: 0
  end
end

$ ->
  # Show form registration
  $('.idea-maker, .product-maker').on 'click', -> $(@).addClass 'active'

  # Send forms
  $productIdeaBtn = $ '#product_idea_btn'
  $productMakerBtn = $ '#product_maker_btn'
  $productMakerForm = $ '#product_maker_form'
  $productMakerPlans = $ '#product_maker_plans'
  $stripeModal = $ '#modal_registraion_stripe'
  $stripeForm = $stripeModal.find 'form'

  ajaxRegistration = (form) ->
    $.post '/ajax/signup', form.serialize()
      .done -> window.location = '/main/sign_success'
      .fail (data) ->
        do hideStripeModal
        toggleStripeButton(false)
        $productMakerForm.removeClass 'hide'
        $productMakerPlans.addClass 'hide'
        alert data.responseJSON.messages

  $productMakerBtn.on 'click', (e) ->
    e.preventDefault()
    $productMakerForm.addClass 'hide'
    $productMakerPlans.removeClass 'hide'

  $productMakerPlans.on 'click', 'input', (e) ->
    if parseFloat(@dataset.price) is 0
      ajaxRegistration($productMakerForm.closest('form'))
    else
      $stripeModal.removeClass 'hide'

  $productIdeaBtn.on 'click', (e) ->
    e.preventDefault()
    ajaxRegistration($(e.target).closest('form'))

  # Stripe
  hideStripeModal = ->
    $stripeModal.addClass 'hide'

  toggleStripeButton = (is_disabled=false) ->
    $stripeForm.find('button')
      .prop 'disabled', is_disabled
      .text if is_disabled then 'Wait...' else 'Send'

  $stripeModal.on 'click', (e) ->
    do hideStripeModal if $(e.target).hasClass('modal-stripe')

  $stripeForm.on 'submit', (e) ->
    e.preventDefault()
    toggleStripeButton(true)

    Stripe.card.createToken $stripeForm, (status, response) ->
      if response.error
        $stripeForm.find('.payment-errors').text response.error.message
        toggleStripeButton(false) # Re-enable submission
      else
        token = response.id # Get the token ID:
        $form = $productMakerForm.closest('form')
        $form.append("<input type='hidden' name='stripe_token' value='#{token}'>")
        ajaxRegistration($form)

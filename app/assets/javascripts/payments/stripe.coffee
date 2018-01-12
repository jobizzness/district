class @PaymentStripe
  constructor: ->
    @formCreateAccount = $ '#create_account'
    @formNeededInformation = $ '#needed_information'
    @buttonSubmitCreateAccount = @formCreateAccount.find 'button'
    @buttonSubmitNeededInformation = @formNeededInformation.find 'button'
    @selectCountry = @formCreateAccount.find '.country'
    @filedTos = @formCreateAccount.find '.tos input'
    do @addEvents

  addEvents: =>
    @formCreateAccount.on 'submit', @setupManaged
    @formNeededInformation.on 'submit', @setupFieldsNeeded
    @filedTos.on 'change', @tosChange
    @selectCountry.on 'change', @countryChange

  tosChange: (e) =>
    @buttonSubmitCreateAccount.prop 'disabled', !e.target.checked

  countryChange: =>
    @filedTos
      .siblings 'a'
      .attr 'href', "https://stripe.com/#{@selectCountry.val().toLowerCase()}/terms"

  setupManaged: (e) =>
    if !@filedTos.is(':checked')
      e.preventDefault()
      return false

    @buttonSubmitCreateAccount
      .prop 'disabled'
      .val 'Please wait...'

  setupFieldsNeeded: (e) =>
    @buttonSubmitNeededInformation
      .prop 'disabled', true
      .text 'Saving...'

    $('#bank-account-error').text ''

    return unless ($bankAccountToken = $('#bank_account_token')).length > 0

    if $bankAccountToken.is(':empty')
      e.preventDefault()

      Stripe.setPublishableKey $bankAccountToken.data('publishableKey')

      Stripe.bankAccount.createToken @formNeededInformation, (_, resp) =>
        if resp.error
          @buttonSubmitNeededInformation
            .prop 'disabled', false
            .text 'Save Info'

          if resp.error.param is 'bank_account'
            $('#bank-account-error').text resp.error.message
          else
            alert resp.error.message
        else
          $bankAccountToken.val resp.id
          @formNeededInformation.get(0).submit()

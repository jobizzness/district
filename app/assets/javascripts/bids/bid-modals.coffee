class BidModals
  MODAL_CLASS = 'modal-bid'
  BTN_SHOW_MODAL = '[data-bid-modal]'
  BTN_CLOSE_MODAL = '[data-close-bid-modal]'
  BTN_MOVE_TO_MODAL = '[data-bid-modal-move-to]'

  constructor: ->
    @modal = $ ".#{MODAL_CLASS}"
    @btnShowModal = $ BTN_SHOW_MODAL
    @btnCloseModal = $ BTN_CLOSE_MODAL
    @btnMoveToModal = $ BTN_MOVE_TO_MODAL
    do @addEvents

  addEvents: =>
    @modal.on 'click', @hideModal
    @btnShowModal.on 'click', @showModal
    @btnCloseModal.on 'click', @hideModal
    @btnMoveToModal.on 'click', @moveToModal

  hideModal: (e) =>
    $self = $(e.target)
    @modal.hide() if $self.hasClass(MODAL_CLASS) or $self.is(BTN_CLOSE_MODAL)
    location.reload() if $self.data('closeBidModal') is 'reload'

  showModal: (e) =>
    e.preventDefault()
    $(e.target.dataset.bidModal).show()

  showNextModal: ($btn) ->
    $($btn.data('bidModalMoveTo')).show()
    $btn.closest(".#{MODAL_CLASS}").hide()

  moveToModal: (e) =>
    $self = $(e.target)

    if $self.data('remote')?
      @charge($self)
    else if $self.data('paymentVerification')?
      @paymentVerification($self)
    else
      @showNextModal($self)

  paymentVerification: ($btn) ->
    $form = $btn.closest(".#{MODAL_CLASS}").find('form')
    $btnRemote = $($btn.data('bidModalMoveTo')).find('[data-remote]').attr('data-stripe-token', '')

    $btn.prop('disabled', true).text 'Wait...'

    Stripe.card.createToken $form, (status, response) =>
      $btn.prop('disabled', false).text 'Next' # Re-enable submission

      if response.error
        $form.find('.payment-errors').text response.error.message
      else
        token = response.id # Get the token ID:
        $btnRemote.attr('data-stripe-token', token)

        @showNextModal($btn)

  charge: ($btn) =>
    $btn.prop('disabled', true).text 'Wait...'

    $.post $btn.data('remote'), stripe_token: $btn.data('stripeToken')
      .done (data) =>
        @showNextModal($btn)
        console.log data
      .fail (data) ->
        alert data.responseJSON.message
      .always ->
        $btn.prop('disabled', false).text 'Send'

$ -> new BidModals

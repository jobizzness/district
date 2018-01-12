class BidExpand
  BID = '[bid]'
  BUTTON = '[btn-bid-expand]'

  constructor: ->
    @button = $(BID).find(BUTTON)
    @button.on 'click', @toggle

  toggle: (e) ->
    return if e.target.localName is 'a'
    $bid = $(@).closest BID
    $bid
      .toggleClass 'opened', !$bid.hasClass 'opened'
      .find '.chat .messages'
      .trigger 'heightChange'

$ -> new BidExpand

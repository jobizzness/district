class BidTabs
  CONTAINER = '[bid-tabs-container]'

  constructor: ->
    @tabs = $(CONTAINER).find '[tab]'
    @buttons = $(CONTAINER).find '[data-tab]'
    @buttons.on 'click', @toggleTab

  toggleTab: (e) =>
    e.preventDefault()

    @buttons.removeClass 'active'
    $(e.target).addClass 'active'

    @tabs.removeClass 'active'
    $($(e.target).data('tab')).addClass 'active'

$ -> new BidTabs

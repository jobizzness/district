class @PaymentsTab
  TAB_BTN = '[data-toggle="tab"]'
  TAB_PANE = '[data-tab="pane"]'

  constructor: ->
    @panes = $ TAB_PANE
    @buttons = $ TAB_BTN
    @buttons.on 'click', @toggle
  
  toggle: (e) =>
    e.preventDefault()

    @buttons.removeClass 'active'
    $(e.currentTarget).addClass 'active'

    @panes.addClass 'hidden'
    $(e.currentTarget.hash).removeClass 'hidden'

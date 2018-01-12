$ ->

  # AFFIX CLASS DEFINITION
  # ======================

  Affix = (element, options) ->
    @options = $.extend {}, Affix.DEFAULTS, options

    @$target = $(@options.target)
      .on 'scroll.bs.affix.data-api', $.proxy(@checkPosition, @)
      .on 'click.bs.affix.data-api',  $.proxy(@checkPositionWithEventLoop, @)

    @$element     = $(element)
    @affixed      = null
    @unpin        = null
    @pinnedOffset = null

    @checkPosition()

  Affix.VERSION  = '3.3.4'

  Affix.RESET    = 'affix affix-top affix-bottom'

  Affix.DEFAULTS =
    offset: 0,
    target: window

  Affix.prototype.getState = (scrollHeight, height, offsetTop, offsetBottom) ->
    scrollTop    = @$target.scrollTop()
    position     = @$element.offset()
    targetHeight = @$target.height()

    return (if scrollTop < offsetTop then 'top' else false) if offsetTop isnt null && @affixed == 'top'

    if @affixed is 'bottom'
      return (if (scrollTop + @unpin <= position.top) then false else 'bottom') if offsetTop isnt null
      return (if (scrollTop + targetHeight <= scrollHeight - offsetBottom) then false else 'bottom')

    initializing   = @affixed is null
    colliderTop    = if initializing then scrollTop else position.top
    colliderHeight = if initializing then targetHeight else height

    return 'top' if (offsetTop isnt null and scrollTop <= offsetTop) 
    return 'bottom' if (offsetBottom isnt null and (colliderTop + colliderHeight >= scrollHeight - offsetBottom))

    return false

  Affix.prototype.getPinnedOffset = ->
    return @pinnedOffset if @pinnedOffset
    @$element.removeClass(Affix.RESET).addClass('affix')
    scrollTop = @$target.scrollTop()
    position  = @$element.offset()
    return (@pinnedOffset = position.top - scrollTop)

  Affix.prototype.checkPositionWithEventLoop = ->
    setTimeout $.proxy(@checkPosition, @), 1

  Affix.prototype.checkPosition = ->
    return unless @$element.is(':visible')

    height       = @$element.height()
    offset       = @options.offset
    offsetTop    = offset.top
    offsetBottom = offset.bottom
    scrollHeight = $(document.body).height()

    offsetBottom = offsetTop = offset if typeof offset isnt 'object'
    offsetTop    = offset.top(@$element) if typeof offsetTop is 'function'
    offsetBottom = offset.bottom(@$element) if typeof offsetBottom is 'function'

    affix = @getState(scrollHeight, height, offsetTop, offsetBottom)

    if @affixed isnt affix
      @$element.css('top', '') if @unpin isnt null

      affixType = 'affix' + (if affix then '-' + affix else '')
      e         = $.Event(affixType + '.bs.affix')

      @$element.trigger(e)

      return if e.isDefaultPrevented()

      @affixed = affix
      @unpin = if affix is 'bottom' then @getPinnedOffset() else null

      @$element
        .removeClass(Affix.RESET)
        .addClass(affixType)
        .trigger(affixType.replace('affix', 'affixed') + '.bs.affix')

    if affix is 'bottom'
      @$element.offset top: scrollHeight - height - offsetBottom


  # AFFIX PLUGIN DEFINITION
  # =======================

  Plugin = (option) ->
    return @each ->
      $this   = $(this)
      data    = $this.data('bs.affix')
      options = typeof option is 'object' and option

      $this.data('bs.affix', (data = new Affix(this, options))) unless data
      data[option]() if typeof option is 'string'

  old = $.fn.affix

  $.fn.affix             = Plugin
  $.fn.affix.Constructor = Affix


  # AFFIX NO CONFLICT
  # =================

  $.fn.affix.noConflict = ->
    $.fn.affix = old
    return this


  # AFFIX DATA-API
  # ==============

  $(window).on 'load', ->
    $('[data-spy="affix"]').each ->
      $spy = $(this)
      data = $spy.data()

      data.offset = data.offset || {}

      data.offset.bottom = data.offsetBottom if data.offsetBottom isnt null
      data.offset.top    = data.offsetTop    if data.offsetTop    isnt null

      Plugin.call $spy, data

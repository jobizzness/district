sendAndReceive = (shown, limit) ->
  $project  = $('.project')
  $projects = $('.projects')
  $loader   = $('.projects-loader')
  $loadMoreBtn = $('#projects-load-more')

  send =
    show: $('.btn-green[data-show]').data 'show'
    order: $('.btn-green[data-order]').data 'order'
    limit: if limit then limit else PROJECT.max

  send.offset = shown.split(',').length if shown and shown.length > 0

  filters =
    show: send.show
    order: send.order
    limit: send.limit

  delete filters[i] if filters[i] is '' or (typeof filters[i] is 'undefined') for i in filters

  unless shown
    $loader.show()
    $projects.hide()

  $.ajax
    url: PROJECT.url
    data: send
    type: 'POST'
    xhrFields: withCredentials: true
    crossDomain: true
    success: (data) ->
      $projects[if shown then 'append' else 'html'](data.html)
      $loader.fadeOut -> $projects.fadeIn()
      filters.limit = $project.length
      do $loadMoreBtn[if data.all is data.count then 'fadeOut' else 'fadeIn']
      window.history.pushState filters, document.title, '?' + $.param(filters)

window.addEventListener 'popstate', (e) ->
  if e.state
    window.history.replaceState e.state, document.title, '?' + $.param(e.state)
    window.location.reload()

$ ->
  $('#projects-load-more').on 'click', (e) ->
    e.preventDefault()
    shown = ''
    $('.project').each -> shown += $(this).data('id') + ','
    shown = shown.substr 0, shown.length - 1
    sendAndReceive shown, 9

  $('[data-show], [data-order]').on 'click', (e) ->
    e.preventDefault()
    return if $(@).is '.btn-green'
    $('[data-' + Object.keys(@.dataset)[0] + ']').removeClass('btn-green').addClass('btn-white')
    $(this).removeClass('btn-white').addClass('btn-green')
    sendAndReceive null, (Object.keys(this.dataset)[0] is "order" && $('.project').length)

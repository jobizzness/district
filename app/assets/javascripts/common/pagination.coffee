$ -> $('.pagination').on 'ajax:complete', (e, data) ->
  if container = e.currentTarget.dataset.container
    $(container).html data.responseText
    $(@).find('li').removeClass 'active'
    $(e.target).parent().addClass 'active'
  else throw new Error 'Pagination: Not specified container element'

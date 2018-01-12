$ ->
  $('#projects-search-form').on 'submit', (e) ->
    e.preventDefault()

    $projects = $('.projects')
    value = $(this).find('input').val()


    if value
      $.ajax
        url: '/ajax/searchProjects'
        data: query: value
        type: 'POST'
        xhrFields: withCredentials: true
        success: (data) ->
          window.history.replaceState e.state, document.title

          if data
            $projects.html(data.html).fadeIn()
          else
            $projects.hide()
          

$ ->
  template = $('#template_production').html()
  $('#production').on 'click', -> $(@).before template
  
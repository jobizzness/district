$ ->
  $('.btn-new-gallery-pic').on 'click', (e) ->
    e.preventDefault()
    $tmpl = $('#new_gallery_pic').html().replace /INDEX/g, $('.gallery-pic-form').length
    $(@).before $tmpl

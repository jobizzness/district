toggleDisabled = (object) ->
  setChange = (checkbox, fields) ->
    $(checkbox).on 'change', ->
      checkboxes = []

      for k, v of object
        if $(k)[0].checked
          checkboxes.push k
          $(fields).attr 'disabled', !@.checked

      if checkboxes.length > 1
        $(c).attr 'disabled', false for c in checkboxes
      else
        $(checkboxes[0]).attr 'disabled', true

  setChange k, v for k, v of object

checkboxes = ->
  $cb = $('.one-cb')
  $cb.on 'change', ->
    checked = $ '.one-cb:checked'
    if checked.length < 2
      checked.on 'click', -> false
    else
      checked.off 'click'
  $cb.trigger 'change'

$ ->
  do checkboxes

  toggleDisabled
    '#samples': '.field-sample'
    '#production': '.field-production'

  $('#distribution').on 'change', -> $('#distribution_field').attr 'disabled', !@checked

  $('#form').validate
    rules:
      'project[attachments_attributes][0][attachment]': filesize: true
      'project[attachments_attributes][1][attachment]': filesize: true
      'project[attachments_attributes][2][attachment]': filesize: true
      'form[logo]': filesize: true

  $('input.datepicker').Zebra_DatePicker format: 'd-m-Y'

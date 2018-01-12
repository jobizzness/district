class @DeliverProject
  DROPZONE = '.dropzone'
  FORM = '#deliver_project_form'
  BTN_SEND_FORM = '[data-dz-send]'
  FIELD_TRACKING_NUMBER = 'input[name="tracking_number"]'

  constructor: (@url) ->
    Dropzone.autoDiscover = false
    @dz = new Dropzone DROPZONE, do @options
    @form = $ FORM
    @btnSendForm = $ BTN_SEND_FORM
    do @addEvents
  
  addEvents: =>
    @dz.on 'sending', @sending
    @dz.on 'queuecomplete', @queuecomplete
    @form.on 'submit', @sendForm

  sending: (file, xhr, formData) ->
    formData.append 'authenticity_token', $('meta[name="token"]').attr('content')
    formData.append 'tracking_number', $(FIELD_TRACKING_NUMBER).val()

  queuecomplete: =>
    location.reload()

  sendForm: (e) =>
    e.preventDefault()

    @form
      .find 'button'
      .addClass 'disabled'
      .prop 'disabled', true
      .text 'Wait...'

    @dz.processQueue()

  options: ->
    url: @url
    maxFiles: 6
    maxFilesize: 5
    uploadMultiple: true
    parallelUploads: 6
    acceptedMimeTypes: 'image/jpeg, image/jpg, image/png'
    paramName: 'photos'
    clickable: '.dropzone, .dropzone *'
    autoProcessQueue: false
    addRemoveLinks: true
    headers: 'x-csrf-token': $('meta[name="csrf-token"]').attr('content')

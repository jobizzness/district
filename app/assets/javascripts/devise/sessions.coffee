$ ->
  $form = $ '.form-signin'
  $fieldEmail = $form.find '[name=email]'
  $fieldPass = $form.find '[name=password]'
  $fieldFid = $form.find '#fid'
  $fieldLid = $form.find '#lid'
  $submit = $form.find '.submit'
  $resetMessage = $form.find '.reset-message'
  $errorMassages = $form.find '.error-massages'

  # Verify CSRF token
  $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  validateEmail = (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    re.test email

  loginFill = (response) ->
    console.log response
    # EMAIL
    $fieldEmail.val response.email
    $fieldEmail.change()

    # FILL HIDDEN SOCIAL FIELD
    $form.find('[name="' + response.inp + '"]').val response.id

  # CHECK SIGNIN INPUTS
  signinCheck = ->
    error = {}

    # validate email
    error.email = 'enter valid email' unless validateEmail $fieldEmail.val() 

    # check pass length
    if $fieldPass.val().length < 6 and $fieldFid.val() is '' and $fieldLid.val() is ''
      error.password = 'at least 6 symbols'

    if jQuery.isEmptyObject error
      true
    else
      for property of error
        $err = $form.find('#' + property + '-error')
        $err.text error[property]
        $err.fadeIn()
      false

  # SIGN IN BUTTON
  $submit.on 'click', (e) ->
    e.preventDefault()

    # IF CHECK RETURNS TRUE
    if signinCheck()
      send = $form.serialize()

      # SEND DATA TO SERVER
      $.ajax
        url: '/ajax/signin'
        data: send
        type: "POST"
        xhrFields: withCredentials: true
        crossDomain: true
        success: (data) ->
          if data.results is 'reset_password'
            $form.find('.inputs-big').fadeOut -> $resetMessage.fadeIn()
          else
            window.location.reload()
        error: (data) ->
          $errorMassages.html $('<p>').html data.responseJSON.messages

  # SIGN IN FACEBOOK
  $('#signin_fb').on 'click', (e) ->
    e.preventDefault()

    # GET STATUS
    FB.getLoginStatus (response) ->
      # IF CONNECTED - FILL INPUTS
      if response.status is 'connected'
        FB.api '/me', (response) ->
          response.inp = 'fid'
          loginFill response
          $submit.click()
      else
        # LOG IN
        FB.login ((response) ->
          if response.authResponse
            # FILL INPUTS
            FB.api '/me', (response) ->
              response.inp = 'fid'
              loginFill response
              $submit.click()
        ), scope: [ 'email' ]

  # CLICK ON LINKEDIN BUTTON
  $('#signin_li').on 'click', (e) ->
    e.preventDefault()
    IN.UI.Authorize().params({"scope":["r_fullprofile", "r_emailaddress","r_contactinfo"]}).place()
    IN.Event.on IN, "auth", onLoginLinkedInAuth

  # LINKED IN AUTH CALLBACK
  onLoginLinkedInAuth = ->
    IN.API.Profile("me").fields([ "id","firstName", "lastName","languages","emailAddress"]).result getProfile

  # LINKED IN PROFILE
  getProfile = (profiles) ->
    member = profiles.values[0]
    response =
      'email': member.emailAddress
      'inp': 'lid'
      'id': member.id
    loginFill response
    $submit.click()

googleSignin = (authResult) ->
  gapi
    .client
    .load 'plus', 'v1', apiClientLoaded

apiClientLoaded = ->
  gapi
    .client
    .plus
    .people
    .get userId: 'me'
    .execute handleEmailResponse

handleEmailResponse = (response) ->
  primaryEmail = ''
  primaryEmail = email.value for email in response.emails when email.type is 'account'
  ajaxSignIn
    gid: response.id
    email: primaryEmail

ajaxSignIn = (data) ->
  $.ajax
    url: '/ajax/signin'
    data: data
    type: 'POST'
    xhrFields: withCredentials: true
    crossDomain: true
    success: (data) -> window.location.reload()
    error: (data) -> alert data.responseJSON.messages

$ ->
  $('#main_signin').on 'submit', (e) ->
    e.preventDefault()

    ajaxSignIn
      email: $('#login_email').val()
      password: $('#login_password').val()

  $('#main_facebook_btn').on 'click', (e) ->
    e.preventDefault()

    fbLogin = (response) ->
      ajaxSignIn
        fid: response.id
        email: response.email

    FB.getLoginStatus (response) ->
      if response.status is 'connected'
        FB.api '/me', fbLogin
      else
        FB.login ((response) ->
          FB.api '/me', fbLogin if response.authResponse
        ), scope: ['email']

  $('#main_google_btn').on 'click', (e) ->
    e.preventDefault()
    gapi.client.setApiKey GG_API_KEY

    gapi.auth.authorize {
      client_id: GG_CLIENT_ID
      scope: GG_SCOPES
      immediate: false
    }, googleSignin

  ($ '.volume-btn i').on 'click', ->
    ($ @).toggleClass 'fa-volume-up fa-volume-off'
    ($ 'video').prop 'muted', ! ($ @).hasClass 'fa-volume-up'

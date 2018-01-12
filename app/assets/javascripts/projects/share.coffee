$ ->
  # FACEBOOK REPOST
  $('.repost-project-to-fb').on 'click', (e) ->
    e.preventDefault()
    $elem = $(@)

    # GET STATUS
    FB.getLoginStatus (response) ->
      # IF CONNECTED - FILL INPUTS
      if response.status is 'connected'      
        # checkPermissions();
        fb_repost $elem
      else
        # LOG IN
        FB.login (response) ->
          fb_repost $elem if response.authResponse
        , scope: ['email']

  # SHARE IN FB
  fb_repost = ($elem) ->
    url = document.URL;
    url += '/' if url.substr(-1, 1) isnt '/'

    link = $elem.attr('href') if $elem.attr('href') and $elem.attr('href') isnt '#'
      
    FB.ui
      method: 'feed'
      link: link || url
      caption: $elem.data 'text'
      picture: $elem.data 'pic'
      description: $elem.data 'description'

  # TWITTER SHARE
  $('.repost-project-to-tw').on 'click', (e) ->
    e.preventDefault()

    link = $(@).data 'url'
    text = $(@).data 'text'
    url  = "https://twitter.com/intent/tweet?url=#{encodeURIComponent(link)}&text=#{encodeURIComponent(text)}"

    $(@).attr 'href', url

  # LINKEDIN SHARE
  $('.repost-project-to-in').on 'click', (e) ->
    e.preventDefault()

    url     = encodeURIComponent($(@).data 'url')
    title   = encodeURIComponent($(@).data 'title')
    summary = encodeURIComponent($(@).data 'summary')
    href    = "http://www.linkedin.com/shareArticle?mini=true&url=#{url}&title=#{title}&summary=#{summary}&source=District2"

    window.open href, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600'

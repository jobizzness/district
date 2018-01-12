$alert = $ '.notice'
closeNotices = -> $alert.addClass 'hide-notice'
setTimeout closeNotices, 5000
$alert.find('.times').on 'click', closeNotices

module Constants
  module Emails
    if Rails.env.development?
      ADMIN = '_sashok_@ukr.net'
      ADMIN_CC = 'sashokua91@gmail.com'
      RELAY_SENDER = '_sashok_@ukr.net'
    elsif Rails.env.production?
      ADMIN = 'cassiebetts@gmail.com'
      ADMIN_CC = 'grebublin@gmail.com'
      RELAY_SENDER = 'District2.co <no-reply@district2.co>'
    end
  end
end

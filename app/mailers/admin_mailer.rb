# encoding: UTF-8
class AdminMailer < ActionMailer::Base
  default from: Constants::Emails::RELAY_SENDER

  def create_company user, company, token
    @user    = user
    @company = company
    @token   = token

    mail( to: user[:email],
          subject: 'Your profile in our database' )
  end
end
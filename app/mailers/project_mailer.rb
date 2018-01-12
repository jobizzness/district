# encoding: UTF-8
class ProjectMailer < ActionMailer::Base
  default from: Constants::Emails::RELAY_SENDER

  def create_project project, company
    @project = project
    @company = company

    mail( to: Constants::Emails::ADMIN,
          cc: Constants::Emails::ADMIN_CC,
          subject: 'Hello mighty D2 admin!' )
  end
end

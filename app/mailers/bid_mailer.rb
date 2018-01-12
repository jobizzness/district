# encoding: UTF-8
class BidMailer < ActionMailer::Base
  default from: Constants::Emails::RELAY_SENDER

  def deliver_project(tracking_number, bid, project)
    @bid = bid
    @project = project
    @tracking_number = tracking_number
    @shipment_photos = bid.shipment_photos

    mail( to: project.user.email,
          cc: Constants::Emails::ADMIN_CC,
          subject: 'Deliver project' )
  end

  def dispute(subject, recipient, bid, project)
    @bid = bid
    @project = project

    mail( to: recipient.email,
          cc: Constants::Emails::ADMIN_CC,
          subject: "Dispute subject: #{subject}" )
  end
end
module MailerMacros
  #returns the last email sent
  def last_email
    ActionMailer::Base.deliveries.last
  end


  #returns the number of emails sent
  def email_count
    ActionMailer::Base.deliveries.count
  end


  #erases all emails sent
  def reset_email
    ActionMailer::Base.deliveries = []
  end
end

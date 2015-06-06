class UserMailer < ApplicationMailer
  include MailerHelper
  default from: COMPANY_EMAIL

  def signup_notification_email(user)
    @user = user

    mail(
      bcc:        set_recipients(ADMIN_EMAILS),
      subject:    set_subject("Someone created a new account on Proto")
    )
  end
end

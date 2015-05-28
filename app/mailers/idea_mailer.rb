class IdeaMailer < ApplicationMailer
  include MailerHelper

  def new_idea_email(idea)
    @idea =           idea
    @idea_owner =     idea.owner

    mail(
      bcc:       set_recipients(ADMIN_EMAILS),
      subject:   set_subject("Someone created an idea on Proto!")
    )
  end


  def new_comment_email(comment, idea)
    @comment =      comment
    @commenter =    comment.user
    @idea =         idea
    @recipients =   idea.all_commenters_except(comment.author) << idea.owner
    @emails =       @recipients.collect(&:email).join(",")

    mail(
      bcc:        @emails,
      subject:    set_subject("#{@commenter.username} commented on your business idea")

    )
  end


  def new_subscriber_email(subscriber, idea)
    @subscriber =       subscriber
    @idea =             idea

    mail(to:        idea.owner.email,
         subject:   "#{@subscriber.username} just subscribed to your idea on Proto")
  end
end

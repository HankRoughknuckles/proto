class IdeaMailer < ApplicationMailer
  default to:     "gogoprototastic@gmail.com"


  def new_idea_email(idea)
    @idea =         idea
    @idea_owner =   idea.owner
    @recipients =   User.where("id != ?", @idea_owner.id)
    @emails =       @recipients.collect(&:email).join(",") + ", #{admin_emails}"

    mail(
      bcc:       @emails,
      subject:  "#{@idea_owner.username} has created a new idea on Proto"
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
      subject:   "#{@commenter.username} commented on your idea on Proto"
    )
  end

  def new_subscriber_email(subscriber, idea)
    @subscriber =       subscriber
    @idea =             idea

    mail(to:        idea.owner.email,
         subject:   "#{@subscriber.username} just subscribed to your idea on Proto")
  end

  private
    def admin_emails
      "thomas.imorris@gmail.com, ina.kiss1@gmail.com, vlad.balan@mylift.ro"
    end
end

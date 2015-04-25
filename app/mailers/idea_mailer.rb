class IdeaMailer < ApplicationMailer
  default to: "thomas.imorris@gmail.com"
  # default to: ["thomas.imorris@gmail.com", 
  #              "ina.kiss1@gmail.com", 
  #              "vlad.balan@mylift.ro"]

  default from: "gogoprototastic@gmail.com"


  def new_idea_email(idea)
    @idea =         idea
    @idea_owner =   idea.owner
    @recipients =   User.where "id != ?", @idea_owner.id

    mail(
      to:       @recipients,
      subject:  "#{@idea_owner.username} has created a new idea on Proto"
    )
  end

  def new_comment_email(comment, idea)
    @comment =      comment
    @commenter =    comment.user
    @idea =         idea

    mail(to:        idea.owner.email,
         subject:   "#{@commenter.username} commented on your idea on Proto")
  end

  def new_subscriber_email(subscriber, idea)
    @subscriber =       subscriber
    @idea =             idea

    mail(to:        idea.owner.email,
         subject:   "#{@subscriber.username} just subscribed to your idea on Proto")
  end
end

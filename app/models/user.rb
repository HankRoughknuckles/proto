class User < ActiveRecord::Base
  has_many :ideas
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def voted_for?(idea)
    vote = self.voted_as_when_voted_for idea
    return vote != nil
  end


  def upvoted?(idea)
    vote = self.voted_as_when_voted_for idea

    return self.voted_for?(idea) && (vote == true)
  end


  def downvoted?(idea)
    vote = self.voted_as_when_voted_for idea

    return self.voted_for?(idea) && (vote == false)
  end
end

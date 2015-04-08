class User < ActiveRecord::Base
  acts_as_voter

  MAX_USERNAME_LENGTH = 30

  has_many :ideas

  # each user can be subscribed to several ideas (i.e. - give their email
  # address for several ideas)
  has_many :subscriptions,  {foreign_key:   "subscriber_id", 
                             dependent:     :destroy}
  has_many :followed_ideas, {through:       :subscriptions, 
                             source:        :idea}

  validates :username, { presence: true, 
                         uniqueness: { case_sensitive: false },
                         length: { maximum: MAX_USERNAME_LENGTH } }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :fill_username_if_blank!  


  has_attached_file :profile_picture, 
    :styles => { :medium => "300x300>", 
                 :thumb => "100x100>" }, 
                 :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :profile_picture, 
    :content_type => ["image/jpg", 
                      "image/jpeg", 
                      "image/png",  
                      "image/gif"]


  def fill_username_if_blank!
    if username.nil?
      name = User.generate_username
      self.username = name
    end
  end


  def self.generate_username
    name = [
      Forgery::Basic.color, 
      Forgery::Address.street_name.split(" ").first, 
      rand(999)
    ].join("-").downcase
  end


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

class User < ActiveRecord::Base
  acts_as_voter

  MAX_USERNAME_LENGTH =       30 #characters
  GOLD_STATUS_DURATION =      7 #days
  PROMOTIONAL_FREE_CREDIT =   true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_attached_file :profile_picture, 
    :styles => { :medium => "300x300>", 
                 :thumb => "100x100>" }, 
                 :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :profile_picture, 
    :content_type => ["image/jpg", 
                      "image/jpeg", 
                      "image/png",  
                      "image/gif"]


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Database Relations
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  has_many :ideas

  # each user can be subscribed to several ideas (i.e. - give their email
  # address for several ideas), these are called a user's followed_ideas
  has_many :subscriptions,  {foreign_key:   "subscriber_id", 
                             dependent:     :destroy}
  has_many :followed_ideas, {through:       :subscriptions, 
                             source:        :idea}

  validates :username, { presence: true, 
                         uniqueness: { case_sensitive: false },
                         length: { maximum: MAX_USERNAME_LENGTH } }


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Validations
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # NOTE: giving gold credit to new users is just promotional for the time
  # being, this will have to be stopped soon after launch. To do this,
  # set User.PROMOTIONAL_FREE_CREDIT to false
  before_validation   :fill_username_if_blank!  
  before_create       :add_gold_credit if PROMOTIONAL_FREE_CREDIT


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Instance Methods
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_username_if_blank!
    if username.nil?
      name = User.generate_username
      self.username = name
    end
  end


  # adds the passed amount of gold credit to the user.  Doesn't save
  def add_gold_credit(amount = 1)
    self.gold_credit += amount
  end


  # adds gold credit to the user, but also saves
  def add_gold_credit!(amount = 1)
    self.add_gold_credit amount
    self.save
  end


  # returns true if the user has any gold credit
  def has_gold_credit?
    self.gold_credit > 0
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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Class Methods
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Gives gold status to a user (doesn't decrement user.gold_credit) and
  # sets xyr gold_status_expiration to GOLD_STATUS_DURATION in the future
  def self.give_free_gold_status_to(user)
    expire_time = User.gold_expiration_time

    user.update_attributes(gold_status: true, 
                           gold_status_expiration: expire_time)
  end


  # Like give_free_gold_status_to, but decrements user.gold_credit
  def self.give_gold_status_to(user)
    if user.nil?
      return false
    elsif user.gold_credit == 0
      user.errors.add :more_gold_credit, "is needed to do that"
      return false
    elsif user.gold_status == true
      user.errors.add :you_already, "have gold status activated"
      return false
    end

    user.gold_status =              true
    user.gold_status_expiration =   User.gold_expiration_time
    user.gold_credit -=             1

    user.save
    return true
  end


  # Removes gold status from the passed user and sets xyr
  # gold_status_expiration to nil
  def self.take_gold_status_from(user)
    user.update_attributes( gold_status: false,
                            gold_status_expiration: nil )
  end


  # returns the datetime for when gold status would expire if it were
  # granted right now.  It will be GOLD_STATUS_DURATION days in the future
  # ending at 23:59:59
  def self.gold_expiration_time
    GOLD_STATUS_DURATION.days.from_now.end_of_day
  end
end

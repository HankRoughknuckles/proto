class Idea < ActiveRecord::Base
  acts_as_votable
  acts_as_commentable

  # MAX_SUMMARY_LENGTH =    the maximum number of characters the idea
  #                         summary can have
  # YOUTUBE_EMBED_PREFIX =  the beginning of the url for embedding youtube
  #                         videos
  # PREFERRED_MAGNITUDE =   how many upvotes a 'preferred status' is worth
  MAX_SUMMARY_LENGTH =          50
  YOUTUBE_EMBED_PREFIX =        "https://www.youtube.com/embed/"
  PREFERRED_MAGNITUDE =         5000


  belongs_to :owner, class_name: "User"
  belongs_to :category

  # each idea can have several different subscribers
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user


  validates_presence_of   :title
  validates               :summary, length: { maximum: MAX_SUMMARY_LENGTH }

  has_attached_file :main_image, 
    :styles => { :poster => "600x350>", 
                 :medium => "300x300>", 
                 :thumb => "100x100>" }, 
                 :default_url => "/images/:style/missing.jpg"

  validates_attachment_content_type :main_image, 
    :content_type => ["image/jpg", 
                      "image/jpeg", 
                      "image/png",  
                      "image/gif"]

  before_save :set_vote_tally!, :set_hotness!

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Instance methods
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  # Sets self.hotness according to the idea's age, upvotes/downvotes, and
  # whether or not the idea has 'preferred' status.
  # Hotness is used to determine where in the list the idea will appear.
  # We've used the same algorithm as reddit does for sorting its contents.
  # At present, having posting an idea later gives more hotness to the
  # idea than upvotes, since vote_weight is calculated using log(10),
  # while the newness of the idea is just newness / 45000.  
  #
  # If an idea has preferred status, it is the equivalent of the idea
  # having PREFERRED_MAGNITUDE extra upvotes when it comes to sorting it
  # in the list.  If if an idea is preferred, PREFERRED_MAGNITUDE = 5000,
  # and has no upvotes, it will have the approximate hotness of an idea
  # posted about 2 days later.  That being the case, if a preferred idea
  # gets no upvotes, it will be overtaken by other ideas about 2 days
  # later.
  #
  # You can see more details about the subject at:
  # http://amix.dk/blog/post/19588
  def set_hotness!
    preferred_weight =      self.preferred ? PREFERRED_MAGNITUDE : 0
    vote_weight =           vote_tally + preferred_weight

    newness =               self.created_at.to_f || Time.now.to_f 
    sign =                  vote_weight < 0 ? -1 : 1
    upvote_magnitude =      [ vote_weight.abs, 1.1 ].max
    order =                 Math.log upvote_magnitude, 10

    self.hotness = sign * order + newness / 45000
  end


  # sets the idea's vote_tally field to be equal to the number upvotes
  # minus the number of downvotes it has
  def set_vote_tally!
    self.vote_tally = self.get_upvotes.size - self.get_downvotes.size
  end


  # Adds a upvote to the idea and then saves it, causing the idea's
  # hotness to update
  def upvote_and_update(user)
    self.liked_by user
    self.save   #trigger set_hotness!
  end


  # Adds a downvote to the idea and then saves it, causing the idea's
  # hotness to update
  def downvote_and_update(user)
    self.disliked_by user
    self.save
  end


  # Returns the tally of votes for the idea (upvotes - downvotes)
  def get_vote_tally
    return self.get_upvotes.size - self.get_downvotes.size
  end


  # Registers the passed user as a subscriber to the idea
  def add_subscriber!(user)
    self.subscribers << user unless self.subscribers.include? user
  end


  # returns true if the instance of idea belongs to the passed user
  def belongs_to?(user)
    return false unless user.instance_of? User
    return self.owner == user
  end

  # converts idea.youtube_link into the form needed to make the video
  # embeddable
  def embed_link
    return nil if self.youtube_link.nil?

    id_regex = /(?:http:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/
    youtube_id = self.youtube_link.match(id_regex)
    return nil if youtube_id.nil?

    return YOUTUBE_EMBED_PREFIX + youtube_id[1] + "?rel=0"
  end


  # Returns true if the idea has preferred status, false otherwise
  def preferred?
    self.preferred
  end
end

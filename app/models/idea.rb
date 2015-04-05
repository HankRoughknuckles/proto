class Idea < ActiveRecord::Base
  MAX_SUMMARY_LENGTH  = 50
  YOUTUBE_EMBED_PREFIX        = "https://www.youtube.com/embed/"

  acts_as_votable
  belongs_to :owner, class_name: "User"
  belongs_to :category

  # each idea can have several different subscribers
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user


  validates_presence_of   :title
  validates               :summary, length: { maximum: MAX_SUMMARY_LENGTH }

  has_attached_file :main_image, 
    :styles => { :poster => "100x300>", 
                 :medium => "300x300>", 
                 :thumb => "100x100>" }, 
                 :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :main_image, 
    :content_type => ["image/jpg", 
                      "image/jpeg", 
                      "image/png",  
                      "image/gif"]


  # Returns the tally of votes for the idea (upvotes - downvotes)
  def vote_tally
    return self.get_upvotes.size - self.get_downvotes.size
  end


  # Registers the passed user as a subscriber to the idea
  def add_subscriber!(user)
    self.subscribers << user
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

    return YOUTUBE_EMBED_PREFIX + youtube_id[1]
  end
end

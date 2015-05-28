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

  MEDIUM_WIDTH =                570
  MEDIUM_HEIGHT =               374


  belongs_to :owner, class_name: "User"
  belongs_to :category

  # each idea can have several different subscribers
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user


  validates_presence_of   :title
  validates               :summary, length: { maximum: MAX_SUMMARY_LENGTH }

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Images
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  has_attached_file :main_image,
    # :styles => { :poster => "600x350#",
    :styles => {
                 :medium => "570x374#",
                 :large =>  "627x411>" },
                 :default_url =>  "/images/:style/missing.jpg",
                 :processors =>   [:cropper]

  validates_attachment_content_type :main_image,
    :content_type => ["image/jpg",
                      "image/jpeg",
                      "image/png",
                      "image/gif"]

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_main_image, :if => :cropping?


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Callbacks
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  before_save :set_vote_tally!, :set_hotness!


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Instance methods
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  # returns true if any of the crop attrs are not blank
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  def main_image_geometry(style = :original)
    @geometry ||= {}
    main_image_path = (main_image.options[:storage] == :s3) ? main_image.url(style) : main_image.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(main_image_path)
  end


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
    unless self.subscribers.include? user
      self.subscribers << user unless self.subscribers.include? user
      IdeaMailer.new_subscriber_email(user, self).deliver_now
    end
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


  # Returns an array of all the users who have commented on the idea
  def all_commenters
    commenters = []
    for comment in self.comment_threads
      commenters << comment.author
    end

    return commenters
  end


  # Returns true if any of the crop attrs are not blank, indicating that
  # an image fo the idea is being cropped.
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end


  # returns an array of all the users who have commented on an idea except
  # for the passed user
  # NOTE: this only works on a single user for now.  This doesn't work if
  # passed multiple users
  def all_commenters_except(user)
    commenters = self.all_commenters
    commenters.delete_if { |commenter| commenter == user }
  end


  def all_commenter_and_owner
    self.all_commenters << self.owner
  end


  def reprocess_main_image
    # main_image.reprocess!
    main_image.assign(main_image)
    main_image.save
  end
end


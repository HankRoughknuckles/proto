class Idea < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  belongs_to :category

  # each idea can have several different subscribers
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user



  validates_presence_of   :title
  validates               :summary, length: { maximum: 50 }

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
end

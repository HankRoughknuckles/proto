class Idea < ActiveRecord::Base
  acts_as_votable
  belongs_to :user

  MISCELLANEOUS =     0
  TECHNOLOGY =        1
  EDUCATION =         2
  FILM =              3

  @@categoryHash = {
    MISCELLANEOUS =>    "Miscellaneous",
    TECHNOLOGY =>       "Technology",
    EDUCATION =>        "Education",
    FILM  =>            "Film"
  }

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


  def vote_tally
    return self.get_upvotes.size - self.get_downvotes.size
  end

  def self.get_string_for_category(category)
    return @@categoryHash[category]
  end
end

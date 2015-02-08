class Idea < ActiveRecord::Base
  acts_as_votable
  belongs_to :user

  has_attached_file :main_image, :styles => { :poster => "100x300>", :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :main_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end

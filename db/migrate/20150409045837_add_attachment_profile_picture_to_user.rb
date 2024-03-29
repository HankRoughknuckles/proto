class AddAttachmentProfilePictureToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :profile_picture
    end
  end

  def self.down
    remove_attachment :users, :profile_picture
  end
end

class AddAttachmentMainImageToIdeas < ActiveRecord::Migration
  def self.up
    change_table :ideas do |t|
      t.attachment :main_image
    end
  end

  def self.down
    remove_attachment :ideas, :main_image
  end
end

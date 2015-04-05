class AddYoutubeLinkToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :youtube_link, :string
  end
end

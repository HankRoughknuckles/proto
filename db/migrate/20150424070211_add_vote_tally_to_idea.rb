class AddVoteTallyToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :vote_tally, :integer
  end
end

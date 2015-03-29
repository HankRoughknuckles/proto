class AddSummaryToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :summary, :string
  end
end

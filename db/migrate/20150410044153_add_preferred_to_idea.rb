class AddPreferredToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :preferred, :boolean, default: false
  end
end

class RenameUserIdToOwnerId < ActiveRecord::Migration
  def change
    rename_column :ideas, :user_id, :owner_id
  end
end

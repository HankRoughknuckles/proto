class AddGoldStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :gold_status, :boolean, default: false
  end
end

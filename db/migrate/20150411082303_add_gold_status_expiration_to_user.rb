class AddGoldStatusExpirationToUser < ActiveRecord::Migration
  def change
    add_column :users, :gold_status_expiration, :datetime, default: nil
  end
end

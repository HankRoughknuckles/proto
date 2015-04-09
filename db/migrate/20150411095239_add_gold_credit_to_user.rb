class AddGoldCreditToUser < ActiveRecord::Migration
  def change
    add_column :users, :gold_credit, :integer, default: 0
  end
end

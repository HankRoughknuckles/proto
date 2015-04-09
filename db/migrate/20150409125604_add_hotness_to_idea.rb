class AddHotnessToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :hotness, :decimal
  end
end

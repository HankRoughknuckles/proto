class AddCategoryToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :category, :integer
  end
end

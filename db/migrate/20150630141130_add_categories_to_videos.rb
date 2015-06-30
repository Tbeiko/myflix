class AddCategoriesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :category, :string
  end
end

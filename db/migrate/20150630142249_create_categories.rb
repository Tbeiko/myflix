class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    remove_column :videos, :category, :string
    add_column :videos, :category_id, :integer
  end
end

class RenameCategoriesPostsTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :categories_posts, :post_categories
  end
end

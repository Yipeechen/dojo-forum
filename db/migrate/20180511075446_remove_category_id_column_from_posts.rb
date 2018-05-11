class RemoveCategoryIdColumnFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :category_id
  end
end

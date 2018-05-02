class CreateCategoriesPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_posts do |t|
      t.integer :category_id
      t.integer :post_id
    end
  end
end

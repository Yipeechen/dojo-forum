class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :image
      t.boolean :status
      t.integer :replies_count, default: 0
      t.integer :viewed_count, default: 0
      t.integer :user_id
      t.integer :category_id
      
      t.timestamps
    end
  end
end

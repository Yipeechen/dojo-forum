class AddLastReplyCreatedAtColumnToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :last_reply_created_at, :datetime
  end
end

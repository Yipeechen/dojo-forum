class AddStatusColumnToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :status, :string
  end
end

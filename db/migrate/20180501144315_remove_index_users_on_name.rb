class RemoveIndexUsersOnName < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :name => 'index_users_on_name'
  end
end

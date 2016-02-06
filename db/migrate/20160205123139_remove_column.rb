class RemoveColumn < ActiveRecord::Migration
def up
    remove_column :users, :uid
  end

end

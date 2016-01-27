class RemoveAgeMinFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :age_min, :integer
  end
end

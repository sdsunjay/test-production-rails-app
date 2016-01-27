class AddAgeMinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age_min, :integer
  end
end

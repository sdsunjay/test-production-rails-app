class AddAgeMaxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age_max, :integer
  end
end

class AddMfileIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :mfile_id, :integer
  end
end

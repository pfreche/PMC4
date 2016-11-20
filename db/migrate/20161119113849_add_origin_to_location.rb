class AddOriginToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :origin, :boolean
  end
end

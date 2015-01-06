class AddTnPrefixToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :prefix, :string
  end
end

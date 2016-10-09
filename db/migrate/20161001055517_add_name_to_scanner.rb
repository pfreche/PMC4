class AddNameToScanner < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :name, :string
  end
end

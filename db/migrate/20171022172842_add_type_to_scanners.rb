class AddTypeToScanners < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :stype, :string
  end
end

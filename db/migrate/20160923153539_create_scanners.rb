class CreateScanners < ActiveRecord::Migration[5.0]
  def change
    create_table :scanners do |t|
      t.string :tag
      t.string :pattern

      t.timestamps
    end
  end
end

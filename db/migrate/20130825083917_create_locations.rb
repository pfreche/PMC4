class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :uri
      t.string :description
      t.integer :typ
      t.integer :storage_id
      t.boolean :inuse

      t.timestamps
    end
  end
end

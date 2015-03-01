class CreateMtypes < ActiveRecord::Migration
  def change
    create_table :mtypes do |t|
      t.string :name
      t.string :icon
      t.string :model
      t.boolean :has_file

      t.timestamps
    end
  end
end

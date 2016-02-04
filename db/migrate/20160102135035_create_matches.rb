class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :pattern
      t.string :extract
      t.string :tag
      t.string :filter

      t.timestamps
    end
  end
end

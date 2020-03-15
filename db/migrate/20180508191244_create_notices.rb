class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :text
      t.integer :mfile_id

      t.timestamps
    end
  end
end

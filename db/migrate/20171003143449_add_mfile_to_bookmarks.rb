class AddMfileToBookmarks < ActiveRecord::Migration[5.0]
  def change
    add_column :bookmarks, :mfile_id, :integer
  end
end

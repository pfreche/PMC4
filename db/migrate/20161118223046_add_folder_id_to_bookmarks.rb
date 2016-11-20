class AddFolderIdToBookmarks < ActiveRecord::Migration[5.0]
  def change
    add_column :bookmarks, :folder_id, :integer
  end
end

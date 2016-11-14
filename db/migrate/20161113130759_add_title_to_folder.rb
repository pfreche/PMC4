class AddTitleToFolder < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :title, :string
  end
end

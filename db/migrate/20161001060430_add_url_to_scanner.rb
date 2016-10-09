class AddUrlToScanner < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :url, :string
  end
end

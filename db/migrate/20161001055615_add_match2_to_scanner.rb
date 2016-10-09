class AddMatch2ToScanner < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :match, :string
  end
end

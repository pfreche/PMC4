class AddAttrToScanner < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :attr, :string
  end
end

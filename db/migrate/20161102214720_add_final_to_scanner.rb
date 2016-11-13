class AddFinalToScanner < ActiveRecord::Migration[5.0]
  def change
    add_column :scanners, :final, :string
  end
end

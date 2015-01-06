class AddMtypeToStorages < ActiveRecord::Migration
  def change
    add_column :storages, :mtype, :integer
  end
end

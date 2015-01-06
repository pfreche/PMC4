class AddMtypeToMfiles < ActiveRecord::Migration
  def change
    add_column :mfiles, :mtype, :integer
  end
end

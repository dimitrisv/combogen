class RemoveSetupFromTricks < ActiveRecord::Migration
  def up
    remove_column :tricks, :setup
  end

  def down
    add_column :tricks, :setup, :string, :default => "N/A"
  end
end

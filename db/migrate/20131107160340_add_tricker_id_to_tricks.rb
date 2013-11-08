class AddTrickerIdToTricks < ActiveRecord::Migration
  def change
    add_column :tricks, :tricker_id, :integer, :default => 1
  end
end

class AddTrickerIdToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :tricker_id, :integer, :default => 1
  end
end

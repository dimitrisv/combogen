class RemoveLandedFromCombos < ActiveRecord::Migration
  def up
    remove_column :combos, :landed
  end

  def down
    add_column :combos, :landed, :string
  end
end

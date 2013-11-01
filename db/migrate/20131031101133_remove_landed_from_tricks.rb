class RemoveLandedFromTricks < ActiveRecord::Migration
  def up
    remove_column :tricks, :landed
  end

  def down
    add_column :tricks, :landed, :string
  end
end

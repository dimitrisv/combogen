class ChangeAdminTricksDefault < ActiveRecord::Migration
  def up
    change_column :tricks, :tricker_id, :integer, :default => nil
  end

  def down
    change_column :tricks, :tricker_id, :integer, :default => 1
  end
end

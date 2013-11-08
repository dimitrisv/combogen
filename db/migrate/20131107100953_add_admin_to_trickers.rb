class AddAdminToTrickers < ActiveRecord::Migration
  def self.up
    add_column :trickers, :admin, :boolean, :default => false
  end
  def self.down
    remove_column :trickers, :admin
  end
end

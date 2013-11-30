class AddTrickTypeToTricks < ActiveRecord::Migration
  def change
    add_column :tricks, :trick_type, :string, :default => "N/A"
  end
end

class ChangeSequenceToTextarea < ActiveRecord::Migration
  def up
    change_column :combos, :sequence, :text
  end

  def down
    change_column :combos, :sequence, :string
  end
end

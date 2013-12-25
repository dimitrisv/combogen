class AddSequenceToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :sequence, :string
  end
end

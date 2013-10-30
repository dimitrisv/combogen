class CreateCombos < ActiveRecord::Migration
  def change
    create_table :combos do |t|
      t.integer :no_tricks
      t.string :landed

      t.timestamps
    end
  end
end

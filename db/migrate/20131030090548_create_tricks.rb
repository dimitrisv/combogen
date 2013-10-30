class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
      t.string :name
      t.string :difficulty
      t.string :setup
      t.string :landed

      t.timestamps
    end
  end
end

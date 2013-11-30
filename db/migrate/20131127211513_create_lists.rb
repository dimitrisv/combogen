class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.belongs_to :tricker
      t.string :name
      t.text :description
      t.string :visibility

      t.timestamps
    end
  end
end

class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.belongs_to :trick
      t.belongs_to :combo
      t.belongs_to :tricker
      t.string :url

      t.timestamps
    end
  end
end

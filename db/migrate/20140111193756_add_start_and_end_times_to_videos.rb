class AddStartAndEndTimesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :start_time, :int, :default => nil
    add_column :videos, :end_time, :int, :default => nil
  end
end

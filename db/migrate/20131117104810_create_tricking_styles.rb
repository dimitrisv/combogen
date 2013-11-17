class CreateTrickingStyles < ActiveRecord::Migration
  def change
    create_table :tricking_styles do |t|
      t.integer :tricker_id
      t.string :name
      t.text :description

      t.timestamps
    end

    # add_column :trickers, :tricking_style_id, :integer, :default => 0

  end
end

class CreateTrickingStylesTricksTable < ActiveRecord::Migration
  def change
    create_table :tricking_styles_tricks, :id => false do |t|
      t.belongs_to :tricking_style
      t.belongs_to :trick
    end
  end
end

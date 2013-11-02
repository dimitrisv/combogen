class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
    	t.integer :combo_id
    	t.integer :trick_id
     	t.integer :index
    	t.timestamps
    end
    add_index :elements, :combo_id
    add_index :elements, :trick_id
  end
end

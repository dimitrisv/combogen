class CreateListElements < ActiveRecord::Migration
  def change
    create_table :list_elements do |t|
      t.integer :combo_id
      t.integer :list_id
      t.integer :index
      t.timestamps
    end
    add_index :list_elements, :combo_id
    add_index :list_elements, :list_id
  end
end

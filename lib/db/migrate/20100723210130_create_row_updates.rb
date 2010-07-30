class CreateRowUpdates < ActiveRecord::Migration
  def self.up
    create_table :row_updates, :force => true do |t|
      t.integer :user_id
      t.integer :row_id, :null => false
      t.string :update_type, :null => false
      t.string :table_name, :null => false
      t.string :column_name
      t.text :before_value
      t.text :after_value
      t.timestamps
    end
  end

  def self.down
    drop_table :row_updates
  end
end

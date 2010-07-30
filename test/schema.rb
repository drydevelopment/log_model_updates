ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string :email, :null => false
    t.timestamps
  end
  
  create_table :posts, :force => true do |t|
    t.string :title
    t.text :body
    t.timestamps
  end
  
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
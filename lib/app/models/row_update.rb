class RowUpdate < ActiveRecord::Base
  validates_presence_of :row_id, :update_type, :table_name
end

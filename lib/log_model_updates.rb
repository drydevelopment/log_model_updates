module LogModelUpdates

	def self.extended(base)
		base.before_save :log_row_updates
		base.after_save :create_row_updates!
		base.send :include, InstanceMethods
	end

	module InstanceMethods
		attr_accessor :current_user
		attr_accessor :row_updates

		def log_row_updates
			@row_updates = []
			update_type = (self.new_record? ? "insert" : "update")
			if update_type == "insert"
				@row_updates << RowUpdate.new(  :user_id => @current_user,
												:row_id => (self.id || nil),
												:update_type => update_type,
												:table_name => self.class.table_name.to_s )
			else
				self.changes.each do |attr|
					@row_updates << RowUpdate.new(  :user_id => @current_user.id,
													:row_id => (self.id || nil),
													:update_type => update_type,
													:table_name => self.class.table_name.to_s,
													:column_name => attr[0],
													:before_value => attr[1][0],
													:after_value => attr[1][1]  )
				end
			end
		end

		def create_row_updates!
			@row_updates.each do |row|
				row.row_id = self.id if row.row_id.nil?
				begin
					row.save!
				rescue
					# TODO: Handle failed insert
				end
			end
		end
	end
end

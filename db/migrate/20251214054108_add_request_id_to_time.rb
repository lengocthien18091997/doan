class AddRequestIdToTime < ActiveRecord::Migration[7.1]
  def change
    add_column :timetables, :request_id, :integer
  end
end

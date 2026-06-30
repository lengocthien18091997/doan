class Timetable < ActiveRecord::Migration[7.1]
  def up
    add_column :timetables, :location, :string
  end

  def down
    remove_column :timetables, :location
  end
end

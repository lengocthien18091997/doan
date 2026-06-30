# db/migrate/xxxxxxxxxx_add_request_id_to_tuitions.rb
class AddRequestIdToTuitions < ActiveRecord::Migration[7.0]
  def change
    add_column :tuitions, :request_id, :integer
  end
end

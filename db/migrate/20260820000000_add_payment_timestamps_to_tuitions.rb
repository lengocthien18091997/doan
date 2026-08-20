class AddPaymentTimestampsToTuitions < ActiveRecord::Migration[7.0]
  def change
    add_column :tuitions, :student_paid_at, :datetime
    add_column :tuitions, :teacher_paid_at, :datetime

    yesterday = Time.zone.yesterday.beginning_of_day
    Tuition.reset_column_information
    Tuition.update_all(student_paid_at: yesterday, teacher_paid_at: yesterday)
  end
end
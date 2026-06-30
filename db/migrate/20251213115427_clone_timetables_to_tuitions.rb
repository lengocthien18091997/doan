class CloneTimetablesToTuitions < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      INSERT INTO tuitions (
        teacher_id,
        student_id,
        timetables_id,
        amount,
        status
      )
      SELECT
        teacher_id,
        student_id,
        id,
        200000 AS amount,
        'new' AS status
      FROM timetables;
    SQL
  end

  def down
    execute <<~SQL
      DELETE FROM tuitions
      WHERE status = 'new' AND amount = 0;
    SQL
  end
end
